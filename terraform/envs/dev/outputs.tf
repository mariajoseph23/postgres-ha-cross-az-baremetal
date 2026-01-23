output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "availability_zones" {
  value = local.azs
}

output "sg_postgres_id" {
  value = aws_security_group.postgres.id
}

output "sg_etcd_id" {
  value = aws_security_group.etcd.id
}

output "sg_haproxy_id" {
  value = aws_security_group.haproxy.id
}
