# 🚀 AWS Docker CI/CD Pipeline

A real-world infrastructure automation project that demonstrates how to build a **CI/CD pipeline** using **Docker**, **GitHub Actions**, and **AWS ECS** with **Terraform**.

## 🔧 Tech Stack

- **AWS**: ECS, EC2, VPC, IAM, CloudWatch
- **CI/CD**: GitHub Actions
- **Infrastructure as Code**: Terraform
- **Containerization**: Docker

## 📦 Features

- Automates deployment of Dockerized applications to AWS ECS
- Provisions infrastructure with Terraform (VPC, IAM, ECS)
- Uses GitHub Actions to build, push, and deploy containers
- Integrates CloudWatch for logging and monitoring
- Secures deployments with environment variable injection

## 🧱 Architecture Overview

```
GitHub → GitHub Actions → Docker Build & Push → Terraform Infra → AWS ECS Fargate → CloudWatch Logs
```

## 🔐 Security Practices

- Secrets managed via GitHub Secrets
- IAM roles scoped with least privilege
- Logs centralized with CloudWatch for audit and observability

## 📂 Folder Structure

```
.
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
├── .github/workflows/
│   └── deploy.yml
├── app/
│   └── Dockerfile
│   └── app.py
└── README.md
```

## ✅ What You’ll Learn

- How to structure production-grade Terraform
- How to automate ECS deployments via CI/CD
- How to inject and secure environment variables in pipelines
- How to use CloudWatch to debug and monitor services

## 🧠 Lessons Learned

- Secrets management is critical in automation
- Terraform modules reduce redundancy in cloud infrastructure
- CI/CD pipelines must include error catching and rollback logic

## 🧪 Future Improvements

- Add staging environment
- Add unit testing before Docker build
- Terraform remote state with backend locking

## 👨‍💻 Author

**Steven Lewis**  
Cloud Engineer | AWS Certified  
GitHub: [sjlewis25](https://github.com/sjlewis25)
