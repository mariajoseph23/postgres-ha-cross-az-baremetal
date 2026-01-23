git commit -m "Step 3: Define VPC, subnets, AZ layout, and security model"

# Networking and Cross-AZ Layout

This document defines the network layout (VPC, subnets, and security rules) for a self-managed PostgreSQL HA cluster deployed across multiple AWS Availability Zones.

---

## 1. Region and Availability Zones

- Region: us-east-1
- Availability Zones (3-AZ layout):
  - AZ-A: us-east-1a
  - AZ-B: us-east-1b
  - AZ-C: us-east-1c

Note: Exact AZ letters may differ per AWS account. Terraform will select the first 3 available AZs in the chosen region.

---

## 2. VPC and subnets

### VPC
- VPC CIDR: 10.20.0.0/16

### Public subnets (one per AZ)
These subnets host EC2 instances in this lab for simplicity, with controlled inbound access via security groups.

- public-a (AZ-A): 10.20.10.0/24
- public-b (AZ-B): 10.20.20.0/24
- public-c (AZ-C): 10.20.30.0/24

Internet access:
- Internet Gateway attached to VPC
- Public subnets route 0.0.0.0/0 to the Internet Gateway

---

## 3. Node placement (cross-AZ)

### PostgreSQL + Patroni nodes (3)
- pg1 in AZ-A
- pg2 in AZ-B
- pg3 in AZ-C

### etcd nodes (3)
- etcd1 in AZ-A
- etcd2 in AZ-B
- etcd3 in AZ-C

### HAProxy nodes (2)
- lb1 in AZ-A
- lb2 in AZ-B

### Client endpoint
- AWS Network Load Balancer (NLB) spans AZ-A and AZ-B and forwards to lb1/lb2 on TCP/5432.

---

## 4. Ports used

- SSH: 22/tcp
- PostgreSQL: 5432/tcp
- Patroni REST API: 8008/tcp
- etcd client: 2379/tcp
- etcd peer: 2380/tcp
- HAProxy stats (optional, not enabled by default): 8404/tcp

---

## 5. Security group model (who can talk to whom)

### Admin IP
- admin_cidr: YOUR_PUBLIC_IP/32 (set in Terraform variables)

### Security groups
- sg_admin_access (optional helper)
- sg_postgres
- sg_etcd
- sg_haproxy
- sg_nlb (NLB does not use a security group, but we control allowed sources at sg_haproxy)

---

## 6. Inbound rules (authoritative)

### sg_postgres (PostgreSQL nodes)
Allow inbound:
- 22/tcp from admin_cidr
- 5432/tcp from sg_haproxy and admin_cidr (admin access for direct testing)
- 8008/tcp from sg_haproxy and admin_cidr (Patroni API used by HAProxy and admin)

### sg_etcd (etcd nodes)
Allow inbound:
- 22/tcp from admin_cidr
- 2379/tcp from sg_postgres and sg_etcd (Patroni and etcd clients)
- 2380/tcp from sg_etcd (etcd peer traffic)

### sg_haproxy (HAProxy nodes)
Allow inbound:
- 22/tcp from admin_cidr
- 5432/tcp from admin_cidr (testing) and 0.0.0.0/0 (only for the NLB target use case)
- 8008/tcp from admin_cidr (optional for troubleshooting Patroni routing decisions)
- 8404/tcp from admin_cidr (optional HAProxy stats if enabled later)

Important: Even though 5432 is open to 0.0.0.0/0 on sg_haproxy for a clean demo with NLB, PostgreSQL itself is not internet-exposed because sg_postgres only allows 5432 from sg_haproxy/admin.

---

## 7. Outbound rules

Default outbound (allow all) is acceptable for this lab to reduce complexity.
Security is enforced through strict inbound rules.

---

## 8. Traffic flow summary

1) Client connects to NLB on TCP/5432
2) NLB forwards to HAProxy nodes (lb1/lb2)
3) HAProxy routes to the current Patroni leader on pg1/pg2/pg3
4) Replication flows from leader to replicas over PostgreSQL streaming replication
5) Patroni coordinates leader election and failover using etcd quorum

