# Architecture

This project builds a cross-AZ PostgreSQL HA cluster on AWS using:

- **PostgreSQL 15**
- **Patroni** for HA orchestration (leader election, failover, switchover)
- **etcd** as the distributed configuration store (DCS)
- **HAProxy** for read/write routing
- **Terraform** for infrastructure

## High-level topology

- **VPC** with **3 public subnets** across **3 AZs**
- **Postgres nodes (3)**, one per AZ:
  - postgres-1 (leader or replica depending on failover/switchover)
  - postgres-2
  - postgres-3
- **etcd nodes (3)**, one per AZ (DCS quorum)
- **HAProxy nodes (2)**, deployed in 2 AZs

## Traffic flow

### Writes
Client -> HAProxy port **5000** -> current Patroni **leader** -> PostgreSQL primary

### Reads
Client -> HAProxy port **5001** -> a Patroni **replica** (round-robin / leastconn) -> PostgreSQL standby

## Key ports

- SSH: **22** (restricted to admin CIDR)
- Postgres: **5432** (intra-cluster)
- Patroni REST API: **8008** (intra-cluster, for health and role checks)
- etcd client: **2379** (Patroni talks to etcd)
- etcd peer: **2380** (etcd node-to-node)
- HAProxy write endpoint: **5000**
- HAProxy read endpoint: **5001**
- HAProxy stats (optional): **8404** (admin only if enabled)

## Evidence
See screenshots under `screenshots/` for:
- Patroni cluster formation and replication health
- Switchover and timeline change
- HAProxy routing to leader/replicas
- Failover validation
