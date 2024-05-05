#!/bin/bash

PASSWORD=$(kubectl get secret js7-pg-app -o jsonpath='{.data.password}' | base64 -d)
HOST=$(kubectl get secret js7-pg-app -o jsonpath='{.data.host}' | base64 -d)
PORT=$(kubectl get secret js7-pg-app -o jsonpath='{.data.port}' | base64 -d)
USERNAME=$(kubectl get secret js7-pg-app -o jsonpath='{.data.username}' | base64 -d)

sed "s/PASSWORD/$PASSWORD/;s/HOST/$HOST/;s/PORT/$PORT/;s/USERNAME/$USERNAME/" hibernate.cfg.xml > .updated-hibernate.cfg.xml

kubectl create configmap hibernate-config --from-file=hibernate.cfg.xml=.updated-hibernate.cfg.xml --dry-run=client -o yaml | kubectl apply -f-

rm -v .updated-hibernate.cfg.xml
