# Docker CI/CD Pipeline (AWS + GitHub Actions + Terraform)

This project builds a fully automated CI/CD pipeline to deploy a Dockerized web app on AWS using GitHub Actions, ECS, and Terraform.

## Why This Project
This project was built to demonstrate a real-world CI/CD pipeline using modern DevOps tools. It automates the deployment of a containerized application from GitHub to AWS with zero manual steps. The focus is on delivering production-ready infrastructure that is scalable, maintainable, and aligned with best practices in cloud automation.

## Architecture
- Terraform – Provisions AWS resources (ECR, ECS, ALB, IAM, etc.)
- GitHub Actions – Automates Docker builds and deployments
- Docker – Containers the web app for consistent deployment
- Amazon ECR – Stores built container images
- Amazon ECS (Fargate) – Runs containers without managing servers
- Application Load Balancer (ALB) – Routes traffic to ECS tasks
- IAM – Manages permissions securely across AWS services

## CI/CD Workflow
1. Code is pushed to the GitHub repository.
2. GitHub Actions workflow is triggered.
3. Workflow builds a Docker image.
4. Image is pushed to Amazon ECR.
5. Terraform applies any infrastructure changes and updates the ECS service.
6. ECS pulls the new image and deploys it behind the ALB.

## File Structure
```
.
├── .github/
│   └── workflows/
│       └── deploy.yml            # GitHub Actions workflow
├── terraform/
│   └── main.tf                   # Infrastructure as Code (Terraform config)
├── app/
│   └── Dockerfile                # Sample containerized web app
├── README.md
└── ...
```

## Lessons Learned
- Building a secure CI/CD pipeline requires strict IAM control and secret management.
- ECS Fargate handles orchestration well but demands clean networking and role setups.
- Terraform state must be handled with care—versioning and modularity matter.
- CI/CD taught me how to trust the pipeline—every step should be reproducible and auditable.
- Logging and error visibility are key to debugging broken pipelines.

## Project Highlights
- Push-to-deploy with no manual steps
- GitHub Actions securely integrates with AWS
- Clean, modular Terraform for infrastructure provisioning
- Real-world CI/CD experience from scratch

## GitHub Repository
View the full project on GitHub: https://github.com/sjlewis25/aws-docker-cicd
