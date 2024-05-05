# Getting Started
0. `cd js7/`
1. install [cloudNativePG](https://github.com/cloudnative-pg/cloudnative-pg/tree/main/releases "find the list of releases") kubernetes operator `kubectl apply --server-side -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.23/releases/cnpg-1.23.1.yaml`
2. create database `kubectl apply -f js7-postgres.yaml`
3. create configmap to mount the hibernate.cfg.xml file with db credentials `./scripts/update_hibernate_config.sh`
4. deploy the controller, agent, & joc pods `kubectl apply -f js7-deployment.yaml`
5. deploy services `kubectl apply -f js7-service.yaml`
6. install database tables `kubectl exec -it js7joc -c js7joc -- bash -c /opt/sos-berlin.com/js7/joc/install/joc_install_tables.sh`

# JS7 login
[thisLink](http://localhost:4446/) should get you to the web UI.
![](./img/'Screenshot 2024-05-05 122803.png'){width=25% height=10% align=left}
the inital username and password will be 'root'.

# Initial Operation
[js7 docs](https://kb.sos-berlin.com/display/JS7/JS7+-+Initial+Operation)
![](./img/'Screenshot 2024-05-05 132649.png'){width=25% height=10% align=left}
![](./img/'Screenshot 2024-05-05 132054.png'){width=25% height=10% align=left}
![](./img/'Screenshot 2024-05-05 133713.png'){width=25% height=10% align=left}
![](./img/'Screenshot 2024-05-05 134224.png'){width=25% height=10% align=left}
![](./img/'Screenshot 2024-05-05 134250.png'){width=25% height=10% align=left}
![](./img/'Screenshot 2024-05-05 134329.png'){width=25% height=10% align=left}

# LATER
`k create secret generic js7-user-credentials --from-literal=username=JS7_USER --from-literal=password=JS7_USER --dry-run=client -o yaml > js7-user-credentials.yaml`
`kubectl create configmap js7-sql-script --from-file=pgsql.sql --dry-run=client -o yaml > js7-sql-script.yaml` create configmap containing js7 init sql

