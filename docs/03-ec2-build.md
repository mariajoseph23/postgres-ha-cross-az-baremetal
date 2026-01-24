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

# Step 6: Provision EC2 nodes (Terraform)

This step provisions compute nodes only (no software install yet):
- 3 etcd nodes
- 3 PostgreSQL nodes
- 2 HAProxy nodes

Evidence captured:
- screenshots/step-06-terraform-outputs.txt
- screenshots/step-06-ec2-inventory.txt

