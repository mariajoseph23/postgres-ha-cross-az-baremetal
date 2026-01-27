# PostgreSQL HA on Self-Managed Servers (Cross-AZ)

This project demonstrates a production-style PostgreSQL High Availability (HA) architecture deployed on self-managed Ubuntu 22.04 servers across multiple AWS Availability Zones.

## What this proves
- Automated leader election and failover (Patroni + etcd)
- Streaming replication across AZs
- Stable client endpoint via AWS NLB + HAProxy
- Operational runbooks: switchover, failover, replica rebuild, lag checks
- Performance and observability: pg_stat_statements, EXPLAIN (ANALYZE, BUFFERS), WAL/checkpoint inspection
- Full infrastructure teardown to control cost

## Repository map
- docs/     Step-by-step build and runbooks
- terraform/ IaC for VPC, EC2, Security Groups, and NLB
- configs/  Patroni, etcd, HAProxy, PostgreSQL configs
- scripts/  Bootstrap, validation tests, teardown helpers
- diagrams/ Architecture diagram source and exports
- screenshots/ Evidence captured during validation

## Quick start
Start with:
- docs/01-prereqs.md
- docs/02-networking.md

## What this project demonstrates

- PostgreSQL 15 high availability using Patroni with etcd as the DCS
- 3 Postgres nodes across 3 AZs with streaming replication
- HAProxy read and write routing using Patroni REST health checks
- Controlled switchover to validate leader changes and timeline behavior
- Automatic failover validation and post failover routing checks
- Terraform managed infrastructure lifecycle and teardown verification

## Architecture at a glance

- etcd cluster (3 nodes) used by Patroni for leader election
- PostgreSQL cluster (3 nodes) managed by Patroni
- HAProxy layer (2 nodes) routing:
  - Port 5000. Write traffic to current leader
  - Port 5001. Read traffic to replicas

## Evidence and outputs

See:
- `docs/` for the runbook style steps
- `screenshots/` for captured command outputs per step

## Cost safety and teardown

This repo is designed to be safe to run in AWS and then fully destroy to stop charges.

Teardown method:
- `terraform destroy` from `terraform/envs/dev`

Post teardown verification (examples):
- No EC2 instances remaining
- No EBS volumes left behind
- No NAT Gateways
- No load balancers or target groups
- No project VPC remaining

Note: Your AWS account will still have the default VPC. That is expected.


