# 👻 Ghostium

**Ghostium** is a serverless proxy that lets you read Medium articles without hitting the Medium paywall — by automatically fetching and returning the Freedium version of the article without visiting the Freedium domain directly.

Useful when:

- You get Medium article links in email but don’t want to pay for a subscription
- Your network blocks Freedium (e.g., on a work laptop)
- You want a clean, simple way to read articles without friction

---

## 🛠️ How It Works

Ghostium is built with:

- **FastAPI** for the web interface
- **Mangum** to adapt FastAPI to run on **AWS Lambda**
- **Poetry** for Python package management
- **Terraform** to manage AWS infra
- Will be deployed via **Lambda container images** behind **API Gateway**

---

## 🚧 Project Status

Currently in early development. Coming soon:

- [x] Project setup with Poetry
- [ ] FastAPI routes for proxying articles
- [ ] Dockerized Lambda container
- [ ] Terraform deployment to AWS
- [ ] Frontend or bookmarklet for easy use

---

## 🧰 Local Development

### ▶️ Run Locally with Poetry

```bash
# Install dependencies
poetry install

# Run the FastAPI dev server using the bin/dev.py script
poetry run ghostium-dev
```

This uses a script in the `bin/` directory to run Uvicorn with hot reloading — great for local development.

Once running, visit [http://localhost:8000](http://localhost:8000)  
You’ll also get Swagger docs at [http://localhost:8000/docs](http://localhost:8000/docs)

---

### 🐳 Run Locally with Docker

> Great for simulating the Lambda container runtime.

```bash
# Build the container
docker build -t ghostium .

# Run the container
docker run -p 8000:8000 ghostium
```

Then visit [http://localhost:8000](http://localhost:8000) in your browser!

---

## 📦 Environment Management

This project includes a `.tool-versions` file for use with [asdf](https://asdf-vm.com/).  
Make sure you have `asdf` and the required plugins installed to match the dev environment.