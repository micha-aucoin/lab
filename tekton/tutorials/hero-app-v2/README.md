# Tekton Pipeline - Hero App v2 Example

a repo to hold CI Pipeline for [Hero Application v2](https://github.com/micha-aucoin/hero-app-v2)

## Namespace Context

```shell
kubectl create ns tekton-temp && \
kubectl create ns dummy && \
kubectl config set-context --current --namespace=dummy
```

## Tasks

```shell
tkn hub install task git-clone
tkn hub install task ansible-runner
tkn hub install task kaniko
kubectl apply -f test.yaml
```

## Pipeline

```shell
kubectl apply -f pipeline.yaml
```

## Storage/ Workspaces

```shell
kubectl apply -f https://raw.githubusercontent.com/micha-aucoin/ansible-runner-temp-db/master/playbooks-pvc.yaml
kubectl apply -f storage
```
```shell
echo $GHCR_TOKEN | docker login ghcr.io -u micha-aucoin --password-stdin

kubectl create secret generic dockerconfig-secret \
  --from-file=config.json=$HOME/.docker/config.json \
  --namespace=dummy
```

## Service Account

create a `dummy` service account in the `dummy` namespace with proper permissions to deploy stuff to the tekton-temp namespace

```shell
kubectl apply -f https://raw.githubusercontent.com/micha-aucoin/ansible-runner-temp-db/master/kubernetes/ansible-deployer.yaml
```

## Run Pipeline

```shell
tkn pipeline start hero-app-v2 \
  --serviceaccount ansible-deployer-account \
  --workspace=name=shared-data,claimName=hero-app-v2 \
  --workspace=name=docker-credentials,secret=dockerconfig-secret \
  --workspace=name=ansible-playbooks,claimName=ansible-playbooks \
  --param=repo-url=https://github.com/micha-aucoin/hero-app-v2.git \
  --param=image-reference=ghcr.io/micha-aucoin/hero-app-v2:latest \
  --labels app=hero-app-v2 \
  --showlog
```

## Backstage

### service account

```shell
kubectl apply -f backstage/bs-RBAC.yaml
kubectl apply -f backstage/sa-secret.yaml
export K8S_RANCHER_DESKTOP_TOKEN=$(kubectl -n default get secret janus-idp-tekton-plugin -o go-template='{{.data.token | base64decode}}')
```
