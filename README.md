AWS Docker CI/CD Pipeline Project

This project demonstrates a real-world, production-style CI/CD pipeline using Docker, GitHub Actions, and AWS (ECS, ECR, S3) managed entirely with Terraform.

Purpose

The goal of this project is to automate the process of building, testing, and deploying Dockerized applications using a secure, scalable AWS architecture—without touching the AWS Console.

Architecture Overview

GitHub Actions: Triggers on code push to build and test Docker image.

Amazon ECR: Stores the built Docker image.

Terraform: Provisions all AWS infrastructure including ECS, ECR, and supporting IAM roles.

Amazon ECS (Fargate): Deploys the container as a service.

S3: Optional usage for storing Terraform state remotely.




Features

Push-to-deploy workflow

Terraform IaC with remote backend support

Rollback-ready ECS deployments

IAM roles configured for least privilege

Logging via CloudWatch

Scalable service architecture


Prerequisites

AWS CLI configured

Terraform installed

GitHub Actions secret keys set for AWS access

Docker installed


How to Deploy

1. Clone the repo


2. Run terraform init to initialize the backend


3. Run terraform apply to provision infrastructure


4. Push your code to the main branch


5. GitHub Actions will:

Build and tag Docker image

Push to ECR

Update ECS task definition




Rollback Strategy

Task definitions are versioned

In case of a failed deploy, ECS can be manually reverted to the last known good revision using AWS CLI:


aws ecs update-service --cluster your-cluster-name --service your-service-name --task-definition previous-task-def:revision

Security

IAM roles follow least-privilege principle

AWS Secrets Manager or GitHub Secrets used for credentials

Network restricted via security groups


Monitoring

CloudWatch Logs enabled for ECS and CI/CD events

Suggested: Add CloudWatch Alarms or SNS notifications for critical failures


Future Enhancements

Blue/Green deployments with CodeDeploy

Integrate with CloudFormation guardrails

Automated test suite before deploy


License

MIT


---

Maintained by [Your Name]. Forks and feedback welcome.


