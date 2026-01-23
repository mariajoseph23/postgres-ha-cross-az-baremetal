variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project tag name."
  type        = string
  default     = "postgres-ha-cross-az-baremetal"
}

variable "owner" {
  description = "Owner tag value."
  type        = string
  default     = "maikbleu"
}

variable "admin_cidr" {
  description = "Your public IP in CIDR notation (example: 108.65.234.217/32)."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "3 public subnet CIDRs, one per AZ."
  type        = list(string)
  default     = ["10.20.10.0/24", "10.20.20.0/24", "10.20.30.0/24"]
}
