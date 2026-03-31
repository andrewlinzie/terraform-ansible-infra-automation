# Terraform Ansible Infrastructure Automation
## Overview
This project implements a fully automated infrastructure provisioning and configuration system on AWS using Terraform and Ansible.

It demonstrates how to provision cloud infrastructure and configure servers in a repeatable, scalable, and production-aligned workflow.

## Purpose
The goal of this project is to eliminate manual infrastructure setup by enabling:

- Reproducible infrastructure creation
- Automated server configuration
- Clear separation between provisioning and configuration layers

This results in a system that is consistent, traceable, and easy to maintain.

## Architecture
### High-Level Flow
1. Terraform provisions AWS infrastructure (EC2, S3, IAM, Security Groups)
2. EC2 instance is created and exposed via public IP
3. Ansible connects to EC2 via SSH
4. Ansible installs and configures NGINX
5. Web application is deployed and served over HTTP

### Core Components
- Terraform – Infrastructure provisioning
- EC2 – Compute layer hosting the application
- Ansible – Configuration management
- NGINX – Web server for content delivery
- S3 – Object storage with IAM-controlled access
- IAM – Role-based access control
- Security Groups – Network access control (SSH + HTTP)

## Provisioning & Configuration Flow
This project follows a provision → configure workflow:
1. Configure AWS credentials and local environment
2. Initialize and validate Terraform configuration
3. Generate and review Terraform execution plan
4. Apply Terraform to provision AWS infrastructure
5. Retrieve outputs (public IP, web URL, S3 bucket)
6. Generate Ansible inventory using EC2 public IP
7. Validate SSH connectivity
8 Execute Ansible playbook
9. Install NGINX and deploy web content
10. Validate application via browser or curl

## Tech Stack
- Terraform
- Ansible
- AWS (EC2, S3, IAM, VPC, Security Groups)
- AWS CLI
- SSH

## Key Engineering Decisions
### Terraform vs Manual Infrastructure Setup
Terraform was used to ensure infrastructure is:
- Declarative
- Version-controlled
- Reproducible

This enables:
- Consistent environment creation
- Prevention of configuration drift
- Safe validation using terraform plan before execution

Manual setup was avoided due to lack of scalability and repeatability.

### Ansible vs User Data Scripts
Ansible was used for configuration management to provide:
- Separation of concerns (infra vs config)
- Idempotent execution (safe re-runs)
- Structured and maintainable automation

User data scripts were avoided due to:
- Limited flexibility
- Poor maintainability for complex workflows
- SSH-Based Configuration Model

### SSH-Based Configuration

SSH enables:
- Secure access via key pairs
- Remote configuration via Ansible inventory
- Validation through manual SSH and Ansible ping

This ensures reliable connectivity before configuration execution.

### Separation of Concerns
The system is intentionally divided:
- Terraform → Infrastructure Layer
- Ansible → Configuration Layer

This improves:
- Maintainability
- Debugging clarity
- Reusability across environments

## Infrastructure Highlights
- EC2 instance with IAM role for S3 access
- S3 bucket with versioning enabled
- Security group allowing HTTP + restricted SSH
- SSH keypair dynamically injected via Terraform
- Terraform outputs expose:
  - Public IP
  - Web URL
  - S3 bucket name

## Notable Features
- Fully automated infrastructure provisioning
- Configuration management via Ansible playbooks
- Idempotent deployments (safe re-runs)
- Dynamic inventory generation for EC2 targeting
- End-to-end workflow from zero infrastructure → live web server
- Security hardening via SSH CIDR restriction

## Deployment / Execution Flow (End-to-End)
1. Install and configure AWS CLI, Terraform, and Ansible
2. Generate SSH keypair and configure Terraform variables
3. Initialize Terraform and run plan for validation
4. Apply Terraform to provision AWS resources
5. Capture outputs (public IP, web URL, bucket name)
6. Generate Ansible inventory using EC2 public IP
7. Validate SSH connectivity and Ansible ping
8. Run Ansible playbook to install NGINX and deploy “Hello, World!”
9. Verify application via browser or curl
10. Restrict SSH access to a specific IP for security hardening
11. Re-apply Terraform to enforce security updates
12. Validate infrastructure, application, and idempotency

## Outcomes
- Eliminated manual infrastructure setup
- Enabled repeatable and consistent environment provisioning
- Established clear separation between infrastructure and configuration
- Improved reliability through idempotent configuration management
- Delivered a fully functional, publicly accessible web server

## Future Improvements
- Move Terraform state to S3 backend with DynamoDB locking
- Modularize Terraform into reusable components
- Add HTTPS via Let's Encrypt
- Implement logging and monitoring
- Introduce CI/CD pipeline for Terraform + Ansible execution

## Summary
This project demonstrates a production-aligned infrastructure automation workflow by combining:
- Infrastructure as Code (Terraform)
- Configuration Management (Ansible)

It showcases the ability to build systems from zero infrastructure → live environment with a focus on automation, reproducibility, and maintainability.