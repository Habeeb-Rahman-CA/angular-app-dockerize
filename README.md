# Dockerized Angular App

This project demonstrates how to run an **Angular application** inside a **Docker container**, supporting both **development** (with live reload) and **production** (served via Nginx) environments.

---

## Table of Contents

* [Prerequisites](#prerequisites)
* [Development Setup](#development-setup)
* [Production Setup](#production-setup)
* [Dockerfile Overview](#dockerfile-overview)
* [Ports](#ports)

---

## Prerequisites

* [Docker](https://www.docker.com/get-started) installed
* [Node.js](https://nodejs.org/) installed (optional, for local dev)
* Angular project already created (`ng new <project-name>`)

---

## Development Setup

This setup allows live reloading of Angular code inside Docker.

1. **Build the Docker image:**

```bash
docker build -t angular-docker .
```

2. **Run the container with volume mounts:**

```bash
docker run -it -p 4200:4200 -v "$(pwd):/app" -v /app/node_modules angular-docker
```

**Explanation of volume mounts:**

* `-v "$(pwd):/app"` → Mounts your project files into the container for live reload.
* `-v /app/node_modules` → Preserves container-installed dependencies.

3. **Access the app in browser:**

```
http://localhost:4200
```

> ⚠️ Make sure the CMD in Dockerfile uses `--host 0.0.0.0`:

```dockerfile
CMD ["npm", "run", "start", "--", "--host", "0.0.0.0"]
```

---

## Production Setup

For production, build the Angular app and serve it using **Nginx**.

1. **Multi-stage Dockerfile example:**

```dockerfile
# Stage 1: Build Angular app
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build -- --configuration production

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=build /app/dist/my-app /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

2. **Build and run production container:**

```bash
docker build -t angular-prod .
docker run -d -p 80:80 angular-prod
```

3. **Access the app in browser:**

```
http://localhost
```

---

## Dockerfile Overview

* **Development:** Runs `ng serve` with `--host 0.0.0.0` for external access
* **Production:** Multi-stage build, final stage serves compiled app via Nginx
* **User permissions:** Optional `app` user for better security

---

## Ports

| Environment | Container Port | Host Port |
| ----------- | -------------- | --------- |
| Development | 4200           | 4200      |
| Production  | 80             | 80        |

---

This setup provides a **flexible way to run Angular in Docker** for both development and production use cases.
