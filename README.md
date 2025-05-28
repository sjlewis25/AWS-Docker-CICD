# Docker CI/CD Pipeline (GitHub Actions + AWS ECS Fargate)

This project demonstrates a complete CI/CD pipeline that deploys a Dockerized web application to AWS using GitHub Actions and ECS Fargate. All AWS infrastructure—including networking, ECR, ECS cluster, task definitions, and services—is provisioned automatically using the AWS CLI. No manual setup is required.

## Why This Project Exists

To simulate a real-world, zero-touch deployment pipeline used in production environments. This setup uses GitHub Actions to handle both application delivery and infrastructure creation in a single push-to-deploy workflow.

## Architecture Overview

- GitHub Actions – Automates the entire CI/CD pipeline  
- Docker – Builds a consistent, portable container image  
- Amazon ECR – Stores Docker images  
- Amazon ECS (Fargate) – Deploys containers without managing servers  
- AWS CLI – Provisions VPC, subnet, route table, security group, ECS cluster, and ECS service  
- IAM – Defines execution role for ECS tasks  

## CI/CD Workflow

1. Push to the `main` branch triggers GitHub Actions  
2. Docker image is built and pushed to ECR  
3. ECS cluster and networking resources are created if missing  
4. Task definition is registered with the new image  
5. ECS service is created or updated to deploy the container  

## File Structure

- .github/
  - workflows/
    - deploy.yml        → GitHub Actions workflow file
- Dockerfile            → Sample app container
- README.md             → Project documentation

## Lessons Learned

- ECS Fargate deployment requires precise networking and IAM configuration  
- Infrastructure creation using the AWS CLI inside a CI/CD pipeline must handle timing and dependency sequencing  
- Dynamic ECS deployments without Terraform are possible, but require careful control flow  
- A push-to-deploy pipeline must be idempotent and error-aware  

## Project Highlights

- Fully automated deployment from GitHub to AWS  
- Docker image built and deployed with no manual steps  
- Infrastructure provisioned on the fly using AWS CLI  
- ECS task and service deployment managed entirely by GitHub Actions  

## GitHub Repository

View the project: [https://github.com/sjlewis25/aws-docker-cicd](https://github.com/sjlewis25/aws-docker-cicd)
