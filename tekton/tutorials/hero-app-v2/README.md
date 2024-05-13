```shell
echo $GHCR_TOKEN | docker login ghcr.io -u micha-aucoin --password-stdin

kubectl create secret generic dockerconfig-secret \
  --from-file=config.json=$HOME/.docker/config.json \
  --namespace=
```

```shell
tkn pipeline start hero-app-v2 \
  --workspace=name=shared-data,claimName=hero-app-v2 \
  --workspace=name=docker-credentials,secret=dockerconfig-secret \
  --param=repo-url=https://github.com/micha-aucoin/hero-app-v2.git \
  --param=image-reference=ghcr.io/micha-aucoin/hero-app-v2:latest \
  --showlog
```
