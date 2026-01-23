# Step 5: Network Provisioning (Terraform Apply)

This step provisions the base network layer used by all cluster nodes:
- VPC
- 3 public subnets across 3 AZs
- Internet Gateway and routes
- Security groups for PostgreSQL, etcd, and HAProxy

## Commands executed

From `terraform/envs/dev`:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform output

