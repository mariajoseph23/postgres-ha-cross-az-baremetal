# Step 9: Patroni + PostgreSQL HA (wired to etcd)

## Postgres nodes
- postgres-1: 10.20.10.158
- postgres-2: 10.20.20.83
- postgres-3: 10.20.30.61

## etcd (DCS)
- 10.20.10.235:2379
- 10.20.20.144:2379
- 10.20.30.15:2379

## Patroni
- REST API port: 8008
- Postgres port: 5432
- Data dir: /var/lib/postgresql/15/patroni

## Validation
```bash
sudo -u postgres patronictl -c /etc/patroni/patroni.yml list

