# Prerequisites

## Local machine (Mac)
- git
- AWS CLI configured with credentials and a default region (example: `us-east-1`)
- Terraform installed (version used during build is OK if >= 1.5)
- SSH keypair for EC2 access (example: `~/.ssh/postgres-ha-key.pem`)
- Optional: GitHub CLI (`gh`) for repo creation and auth

## AWS requirements
- An AWS account with permissions to create:
  - VPC, subnets, route tables, internet gateway
  - security groups
  - EC2 instances
- Your **admin public IP** as a **/32** CIDR for SSH ingress.
  - Important: do not commit your real public IP into the repo.
  - Use `terraform/envs/dev/terraform.tfvars.example` as a template and keep the real `terraform.tfvars` ignored.

## Repo structure
- `terraform/` contains IaC modules and envs
- `docs/` contains the runbook chapters
- `screenshots/` contains captured outputs used as evidence in documentation

## Quick sanity checks
```bash
aws sts get-caller-identity
terraform -version
git --version

