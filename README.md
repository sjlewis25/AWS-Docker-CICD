# AWS Docker CI/CD Project

## Overview
This project demonstrates a complete CI/CD pipeline on AWS for deploying Dockerized applications. The goal is to show how code changes are automatically built, tested, and deployed into a scalable cloud environment with no manual intervention.

It reflects a real-world use case for teams who want to containerize apps and automate deployment using modern DevOps practices.

---

## Architecture

- **Source Control**: GitHub
- **CI/CD Pipeline**: GitHub Actions (or AWS CodePipeline)
- **Container Registry**: Amazon ECR
- **Compute**: ECS Fargate (or EC2 with Docker)
- **Infrastructure**: Provisioned with Terraform
- **Monitoring**: CloudWatch (basic setup)
- **Security**:
  - IAM roles scoped to least privilege
  - Private ECR repositories
  - VPC/subnet isolation (if applicable)

---

## Key Features

- Push-to-deploy pipeline: code pushed to `main` triggers a full redeploy
- Docker image is automatically built and pushed to ECR
- ECS service (or EC2) pulls new image and restarts with zero downtime
- Configurable via Terraform for repeatable, version-controlled deployments

---

## How It Works

1. Developer pushes code to GitHub
2. GitHub Actions workflow:
   - Lints Terraform
   - Builds Docker image
   - Pushes image to Amazon ECR
   - Deploys infra (if changed)
3. ECS (or EC2) service pulls the new image and restarts container

---

## Deployment Steps

### 1. Clone the repo
```bash
git clone https://github.com/sjlewis25/aws-docker-cicd.git
cd aws-docker-cicd
```

### 2. Set your variables
Edit `terraform.tfvars` or use environment variables to configure:
- AWS region
- ECR repo name
- VPC/Subnet IDs
- ECS cluster name (if applicable)

### 3. Deploy
```bash
terraform init
terraform plan
terraform apply
```

---

## CI/CD Workflow (GitHub Actions)

```yaml
# .github/workflows/deploy.yml (example)
name: CI/CD Pipeline

on:
  push:
    branches: [main]

jobs:
  build-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Docker
        uses: docker/setup-buildx-action@v2

      - name: Build Docker Image
        run: docker build -t my-app .

      - name: Push to ECR
        run: |
          aws ecr get-login-password | docker login --username AWS --password-stdin <your-ecr-repo>
          docker tag my-app:latest <your-ecr-repo>:latest
          docker push <your-ecr-repo>:latest

      - name: Deploy Terraform
        run: |
          terraform init
          terraform apply -auto-approve
```

---

## Security Considerations

- IAM roles scoped to specific actions (e.g., ECR push, ECS update)
- No hardcoded secrets; use GitHub Secrets or AWS SSM
- VPC isolation enabled if using ECS Fargate
- All traffic via HTTPS

---

## Lessons Learned

- How to automate end-to-end infrastructure + app deployments
- Importance of separating infra and app logic
- Real-world ECS deployment flow using Terraform and Docker

---

## Future Improvements

- Add automated testing step in CI
- Blue/green or canary deployments via ECS
- Alerting and rollback mechanisms

---

## Author

**Steven Lewis**  
[GitHub](https://github.com/sjlewis25)  
Cloud Engineer | AWS | Terraform | CI/CD | Serverless
