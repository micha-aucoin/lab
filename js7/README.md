### Environment
<table>
    <tr>
        <th>Logo</th>
        <th>Name</th>
        <th>Description</th>
    </tr>
    <tr>
        <td><img width="32" src="https://rancherdesktop.io/images/icon-rancher-desktop.svg"></td>
        <td><a href="https://rancherdesktop.io/">Rancher Desktop</a></td>
        <td>Container Management and Kubernetes on the Desktop</td>
    </tr>
</table>

## Getting Started

change directory
```shell
cd js7/
```
install [cloudNativePG](https://github.com/cloudnative-pg/cloudnative-pg/tree/main/releases "find the list of releases") kubernetes operator 
```shell
kubectl apply --server-side -f \
https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.23/releases/cnpg-1.23.1.yaml
```
create database
```shell
kubectl apply -f js7-postgres.yaml
```
create configmap to mount the hibernate.cfg.xml file with db credentials
```shell
./scripts/update_hibernate_config.sh
```
deploy the controller, agent, & joc pods
```shell
kubectl apply -f js7-deployment.yaml
```
deploy services
```shell
kubectl apply -f js7-service.yaml
```
install database tables
```shell
kubectl exec -it js7joc -c js7joc -- bash -c /opt/sos-berlin.com/js7/joc/install/joc_install_tables.sh
```

## [JS7 login](http://localhost:4446/)
Inital username and password will be `root`.<br><br>
<img src="./img/login.png" width="300">

<br>

## [Initial Operation](https://kb.sos-berlin.com/display/JS7/JS7+-+Initial+Operation)
<img src="./img/register_controller.png">
<img src="./img/manage_controllers_agents.png">
<img src="./img/add_standalone_agent.png">
<img src="./img/add_new_agent.png">
<img src="./img/deploy_agent.png">
<img src="./img/dashboard.png">

<br>

## LATER
create generic secret for js7 db user
```shell
kubectl create secret generic js7-user-credentials \
--from-literal=username=JS7_USER \
--from-literal=password=JS7_USER \
--dry-run=client -o yaml > js7-user-credentials.yaml
```
create configmap containing js7 init sql
```shell
kubectl create configmap js7-sql-script \
--from-file=pgsql.sql --dry-run=client -o yaml > js7-sql-script.yaml
```

