# 🚀 Blue-Green Deployment with Docker & CI/CD

A production-grade **Blue-Green Deployment system** implemented using **Docker, Docker Compose, Nginx, and GitHub Actions (CI/CD)**.  
This project demonstrates **zero-downtime deployments**, secure container practices, and automated traffic switching between application versions.

---

## 📌 Key Highlights

- ✅ Blue-Green deployment strategy
- ✅ Zero-downtime application releases
- ✅ Dockerized backend services
- ✅ Nginx reverse proxy with dynamic upstream switching
- ✅ CI/CD pipeline using GitHub Actions (self-hosted runner)
- ✅ Secure Docker best practices
- ✅ Automatic traffic switch after successful deployment
- ✅ Rollback-ready architecture

---

## 🧠 What is Blue-Green Deployment?

Blue-Green Deployment is a release strategy where:
- Two identical environments (**Blue** and **Green**) run in parallel
- Only one environment serves production traffic
- New versions are deployed to the **idle environment**
- Traffic is switched instantly after verification

This enables:
- 🚫 Zero downtime
- 🔁 Instant rollback
- 🛡 Safer releases

---

## 🧩 Tech Stack

| Component | Technology |
|--------|------------|
| Backend | Node.js (Dockerized) |
| Reverse Proxy | Nginx |
| Containerization | Docker |
| Orchestration | Docker Compose |
| CI/CD | GitHub Actions |
| Deployment Strategy | Blue-Green |
| Security | Docker hardening practices |

---

## ⚙️ Prerequisites

Ensure the following are installed:

- Docker ≥ 24.x
- Docker Compose v2
- Git
- Linux environment (recommended)
- GitHub account (for CI/CD)

---

## ▶️ Running the Project Locally

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/your-username/blue-green-deployment.git
cd blue-green-deployment

2. Create the Docker Network

docker network create backend-network

3. Start Blue & Green Backends

docker compose -p backend-network -f deploy/docker-compose.blue.yml up -d
docker compose -p backend-network -f deploy/docker-compose.green.yml up -d

4. Start Nginx Reverse Proxy

docker compose -p backend-network -f deploy/docker-compose.nginx.yml up -d

5. Verify the Deployment

curl http://localhost/version

## Switching Traffic Manually

chmod +x deploy/switch.sh
./deploy/switch.sh

## Rollback Strategy

./deploy/switch.sh
