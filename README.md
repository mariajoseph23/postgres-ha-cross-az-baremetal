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
