# PostgreSQL High Availability on AWS Using Patroni, etcd, and HAProxy (Terraform Lab)

## Why I built this project

I built this project to demonstrate a real PostgreSQL high availability setup. Not just installing tools, but validating leader election, controlled switchovers, automatic failover, and read/write routing in a multi AZ environment.

This lab is designed to be:
- Production realistic
- Fully reproducible with Terraform
- Fully destroyable to avoid ongoing cloud costs

## Target architecture

The architecture is intentionally simple but complete.

- **etcd cluster (3 nodes)**  
  Used by Patroni as the distributed configuration store (DCS) for leader election and cluster state.

- **PostgreSQL cluster (3 nodes)**  
  PostgreSQL 15 managed by Patroni with streaming replication across three Availability Zones.

- **HAProxy layer (2 nodes)**  
  Routes traffic based on Patroni REST API health checks.

### Traffic routing

- **Write traffic**  
  HAProxy port `5000` routes to the current Patroni leader.

- **Read traffic**  
  HAProxy port `5001` routes to available replicas.

## Infrastructure as Code

All infrastructure was created using Terraform and includes:

- VPC and subnets across three Availability Zones
- Security groups for etcd, PostgreSQL, and HAProxy
- EC2 instances for:
  - etcd
  - PostgreSQL
  - HAProxy

All resources were later destroyed using `terraform destroy`.

## Implementation flow (mapped to the repository)

This article maps directly to the step by step runbook in the repository.

- **Step 7** – etcd cluster setup and health validation  
- **Step 8–9** – PostgreSQL 15 installation and Patroni cluster bootstrap  
- **Step 10** – Controlled switchover and timeline change validation  
- **Step 11** – HAProxy read/write routing configuration  
- **Step 12** – Failover testing and post failover routing validation  
- **Step 13** – Full teardown and cost safety verification  

See:
- `docs/` for detailed commands and explanations
- `screenshots/` for captured evidence from each step

## Key validations performed

### Patroni cluster formation
Validated that the cluster formed with:
- One leader
- Two streaming replicas

### Controlled switchover
Performed a manual switchover to a chosen replica and validated:
- Leader changed successfully
- Timeline incremented as expected
- Replication continued without data loss

### HAProxy routing
Validated that:
- Port `5000` always routes to the leader
- Port `5001` routes to replicas

### Automatic failover
Simulated leader failure and validated:
- Patroni elected a new leader automatically
- HAProxy write traffic followed the new leader
- HAProxy read traffic continued to function

## Lessons learned

- Security group rules must explicitly allow:
  - PostgreSQL intra cluster traffic on port 5432
  - Patroni REST API access on port 8008
- Patroni switchovers require a clean cluster state and viable candidates
- Capturing evidence during execution makes documentation and interviews far easier

## Teardown and cost safety

After validation, all AWS resources were destroyed using Terraform.

Post teardown checks confirmed:
- No EC2 instances remained
- No EBS volumes left behind
- No NAT Gateways
- No load balancers or target groups
- No project specific VPC remained

The AWS default VPC remains. This is expected.

## Conclusion

This project demonstrates practical PostgreSQL high availability operations including leader election, switchover, failover, and read/write routing, implemented in a reproducible Terraform lab.


