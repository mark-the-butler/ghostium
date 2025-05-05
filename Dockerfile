#### Stage 1: Builder
FROM python:3.11-slim AS builder

# Install Poetry
ENV POETRY_VERSION=2.1.3
ENV PATH="/root/.local/bin:$PATH"

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl build-essential && \
    curl -sSL https://install.python-poetry.org | python3 -

WORKDIR /ghostium

# Copy only what we need to install
COPY pyproject.toml poetry.lock ./
COPY app/ ./app/

# Install runtime dependencies
RUN poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi --no-root && \
    rm -rf ~/.cache/pypoetry ~/.cache/pip && \
    apt-get purge -y build-essential && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Clean up build artifacts, pip, setuptools, wheel, and other unneeded files
RUN rm -rf ~/.cache/pypoetry ~/.cache/pip && \
    rm -rf /usr/local/lib/python3.11/site-packages/pip* \
           /usr/local/lib/python3.11/site-packages/setuptools* \
           /usr/local/lib/python3.11/site-packages/wheel* \
           /usr/local/lib/python3.11/site-packages/pkg_resources \
           /usr/local/lib/python3.11/site-packages/__pycache__ \
           /usr/local/lib/python3.11/site-packages/*.dist-info

#### Stage 2: Production (Lambda)
FROM public.ecr.aws/lambda/python:3.11 AS production

WORKDIR /var/task

ENV PYTHONPATH="/var/task/python"

# Copy only installed packages and app code from builder
COPY --from=builder /usr/local/lib/python3.11/site-packages ./python/
COPY --from=builder /ghostium/app ./app/

# Lambda handler path
CMD ["app/lambda_handler.handler"]

#### Stage 3: Dev
FROM python:3.11-slim AS dev

# Install Poetry
ENV POETRY_VERSION=2.1.3
ENV PATH="/root/.local/bin:$PATH"

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl build-essential && \
    curl -sSL https://install.python-poetry.org | python3 -

WORKDIR /ghostium

# Copy everything for local development
COPY pyproject.toml poetry.lock ./
COPY app/ ./app/
COPY bin/ ./bin/

# Install all dependencies
RUN poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi --no-root

RUN rm -rf ~/.cache/pypoetry ~/.cache/pip && \
    apt-get purge -y build-essential && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Run dev script
CMD ["poetry", "run", "ghostium-dev"]