# Step 11: HAProxy Read/Write Routing for Patroni

## Objective
Configure HAProxy to route:
- Writes to the Patroni leader (port 5000)
- Reads to Patroni replicas (port 5001)

## Architecture
- HAProxy-1 and HAProxy-2 run active-active
- Patroni REST API used for health checks
- PostgreSQL leader discovered dynamically

## Validation

### Listener Ports
Both HAProxy nodes listen on:
- 5000 (write / primary)
- 5001 (read / replicas)

### Write Routing Test
```sql
select inet_server_addr(), pg_is_in_recovery();
