#!/bin/bash

set -x

cd $(dirname "${BASH_SOURCE[0]}")

# configure greymatter CLI to communicate with Control API
source ./env

cd 1_kubernetes
kubectl delete -f deployment.yaml

cd ../2_sidecar
greymatter delete domain fibonacci-domain
greymatter delete listener fibonacci-listener
greymatter delete cluster fibonacci-cluster
greymatter delete shared_rules fibonacci-local-rules
greymatter delete route fibonacci-local-route
greymatter delete proxy fibonacci-proxy

cd ../3_edge
greymatter delete cluster edge-to-fibonacci-cluster
greymatter delete shared_rules edge-to-fibonacci-rules
greymatter delete route edge-to-fibonacci-route-slash

#cd ../4_catalog
#greymatter delete catalog-service fibonacci

cd ..

# REMOVE OPERATOR ONES
greymatter delete proxy fibonacci

greymatter delete route fibonacci
greymatter delete route fibonacci:8080
greymatter delete route fibonacci:8081
greymatter delete route fibonacci:10808
greymatter delete route fibonacci-to-gm-redis

greymatter delete shared_rules fibonacci
greymatter delete listener fibonacci
greymatter delete listener fibonacci-egress-tcp-to-gm-redis

greymatter delete domain fibonacci
greymatter delete domain fibonacci-egress-tcp-to-gm-redis

greymatter delete cluster fibonacci
greymatter delete cluster fibonacci:8080
greymatter delete cluster fibonacci:8081
greymatter delete cluster fibonacci:10808
greymatter delete cluster fibonacci-to-gm-redis

greymatter delete catalog-service fibonacci
