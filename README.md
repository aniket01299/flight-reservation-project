# ✈️ Flight Reservation System - End-to-End DevOps Deployment on AWS

> A production-style Flight Reservation application deployed on AWS using Terraform, Docker, Kubernetes (Amazon EKS), Jenkins, SonarQube, and S3 with a fully automated CI/CD pipeline.

---

# 📌 Project Overview

This project demonstrates a complete DevOps workflow for deploying a Flight Reservation application on AWS.

The project includes:

- ✅ Infrastructure Provisioning using Terraform
- ✅ Backend Deployment on Amazon EKS
- ✅ Frontend Deployment on Amazon S3
- ✅ Docker Containerization
- ✅ CI/CD using Jenkins
- ✅ Static Code Analysis using SonarQube
- ✅ DockerHub Image Registry
- ✅ Kubernetes LoadBalancer Service

---

# 🛠️ Tech Stack

- AWS
- Terraform
- Jenkins
- Docker
- DockerHub
- Kubernetes (Amazon EKS)
- Spring Boot
- React + Vite
- SonarQube
- Maven
- Amazon S3

---

# 📂 Project Structure

```
Flight Reservation Project

├── flight-reservation-backend
│      ├── Dockerfile
│      ├── Jenkinsfile
│      ├── Kubernetes YAML
│      └── Spring Boot Source Code
│
├── flight-reservation-frontend
│      ├── React Source
│      ├── Jenkinsfile
│      ├── .env
│      └── Vite
│
└── flight-reservation-infra-terraform
       ├── VPC
       ├── EKS
       ├── IAM
       ├── Security Groups
       └── Networking
```

---

# 🚀 Deployment Steps

## ⭐ Step 1 - Provision AWS Infrastructure

* Initialize Terraform

```bash
terraform init
```

* Review execution plan

```bash
terraform plan
```

* Create infrastructure

```bash
terraform apply
```

* Configure kubectl

```bash
aws eks update-kubeconfig --region ap-south-1 --name vanraj-cluster
```

* Verify worker nodes

```bash
kubectl get nodes
```

---

## ⭐ Step 2 - Build Backend

* Package Spring Boot application

```bash
mvn clean package -DskipTests
```

---

## ⭐ Step 3 - Build Docker Image

* Build Docker image

```bash
docker build -t flight-backend:1 .
```

* Tag Docker image

```bash
docker tag flight-backend:1 aniiket2025/flight-backend:1
```

* Push image to DockerHub

```bash
docker push aniiket2025/flight-backend:1
```

---

## ⭐ Step 4 - Deploy Backend on Kubernetes

* Create Namespace

```bash
kubectl apply -f namespace.yaml
```

* Deploy Backend

```bash
kubectl apply -f deployment.yaml
```

* Create Service

```bash
kubectl apply -f service.yaml
```

* Verify Pods

```bash
kubectl get pods -n flight-reservation
```

* Verify Service

```bash
kubectl get svc -n flight-reservation
```

---

## ⭐ Step 5 - Obtain LoadBalancer DNS

* Execute

```bash
kubectl get svc -n flight-reservation
```

Example Output

```
a230026d005674d76ae12b5c81147076.ap-south-1.elb.amazonaws.com
```

---

## ⭐ Step 6 - Configure Frontend

* Create a `.env` file

```env
VITE_API_URL=http://<LOADBALANCER-DNS>

VITE_API_CHECKIN_URL=http://<SERVER_PUBLIC_IP>:8080
```

Example

```env
VITE_API_URL=http://a230026d005674d76ae12b5c81147076.ap-south-1.elb.amazonaws.com

VITE_API_CHECKIN_URL=http://13.201.40.6:8080
```

* Install dependencies

```bash
npm install
```

* Build frontend

```bash
npm run build
```

* Deploy to Amazon S3

```bash
aws s3 sync dist/ s3://vanraj-flight-reservation --delete
```

---

# ⚙️ Jenkins CI/CD Pipeline

## Backend Pipeline

* ✅ Code Checkout
* ✅ Maven Build
* ✅ SonarQube Scan
* ✅ Quality Gate
* ✅ Docker Build
* ✅ Docker Push
* ✅ Deploy to Amazon EKS

---

## Frontend Pipeline

* ✅ Code Checkout
* ✅ npm Install
* ✅ React Build
* ✅ Upload Build to Amazon S3

---

# 🔍 SonarQube Analysis

* Analyze source code

```bash
mvn clean verify sonar:sonar
```

* Jenkins waits for the Quality Gate before proceeding with deployment.

---

# 🐳 Docker Image Versioning

Each build creates a unique version:

```
flight-backend:1

flight-backend:2

flight-backend:3

...
```

The pipeline also updates:

```
flight-backend:latest
```

This allows Kubernetes to always pull the latest image or use a fixed version for stable deployments.

---

# 🚨 Challenges Faced & Solutions

## 🔴 Problem 1 - ImagePullBackOff

### Cause

Deployment was configured with:

```
aniiket2025/flight-backend:latest
```

but the `latest` tag was not available on DockerHub.

### Solution

* Tagged every build as `latest`

```bash
docker tag flight-backend:6 aniiket2025/flight-backend:latest

docker push aniiket2025/flight-backend:latest
```

---

## 🔴 Problem 2 - AWS InvalidSignatureException

### Cause

Incorrect AWS Secret Access Key in Jenkins Credentials.

### Solution

* Updated AWS credentials in Jenkins.
* Deployment completed successfully.

---

## 🔴 Problem 3 - SonarQube Quality Gate Stuck

### Cause

Webhook was not configured.

### Solution

Added webhook:

```
http://13.201.40.6:8080/sonarqube-webhook/
```

After configuring the webhook, the Quality Gate completed successfully.

---

## 🔴 Problem 4 - Backend LoadBalancer Not Working

### Cause

Backend Pods were not running because of the image pull failure.

### Solution

* Fixed the Docker image.
* Redeployed the application.
* Pods became Ready.
* AWS automatically attached healthy targets to the LoadBalancer.

---

## 🔴 Problem 5 - Frontend Could Not Connect to Backend

### Cause

Frontend `.env` contained an outdated API endpoint.

### Solution

Updated:

```env
VITE_API_URL=http://<LOADBALANCER-DNS>
```

Rebuilt the React application and uploaded the latest build to Amazon S3.

---

# 📈 Key Learnings

Throughout this project, I gained practical experience in:

- ✅ Infrastructure as Code using Terraform
- ✅ Docker Image Creation & Versioning
- ✅ Amazon EKS Deployment
- ✅ Kubernetes Services & LoadBalancers
- ✅ Jenkins CI/CD Pipelines
- ✅ SonarQube Integration
- ✅ Amazon S3 Static Website Hosting
- ✅ DockerHub Image Management
- ✅ Kubernetes Troubleshooting
- ✅ AWS Networking
- ✅ Production Deployment Workflow

---

# 🔧 Useful Commands

* Check Pods

```bash
kubectl get pods -A
```

* Check Services

```bash
kubectl get svc -A
```

* Check Deployments

```bash
kubectl get deployment -A
```

* Describe Pod

```bash
kubectl describe pod <pod-name>
```

* View Pod Logs

```bash
kubectl logs <pod-name>
```

* Restart Deployment

```bash
kubectl rollout restart deployment flight-reservation-app -n flight-reservation
```

---

# 🚀 Future Improvements

- GitOps using ArgoCD
- Prometheus Monitoring
- Grafana Dashboard
- Trivy Image Scanning
- OWASP Dependency Check
- Blue-Green Deployment
- Horizontal Pod Autoscaler (HPA)
- AWS Route53
- HTTPS with ACM
- NGINX Ingress Controller

---

# 👨‍💻 Author

## Aniket Siraskar

**DevOps Engineer**

AWS • Docker • Kubernetes • Terraform • Jenkins • SonarQube • CI/CD • Linux • Git • Maven

---

## ⭐ If you found this project useful, consider giving it a Star on GitHub!
