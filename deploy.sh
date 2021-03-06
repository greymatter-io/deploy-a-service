#!/bin/bash
set -x

cd $(dirname "${BASH_SOURCE[0]}")

# configure greymatter CLI to communicate with Control API
source ./env

# deploy to Kubernetes
cd 1_kubernetes
kubectl apply -f deployment.yaml

sleep 10

# REMOVE OPERATOR ONES
greymatter delete proxy fibonacci

greymatter delete route fibonacci
greymatter delete route fibonacci:8080
greymatter delete route fibonacci:8081
greymatter delete route fibonacci:10808
greymatter delete route fibonacci-to-gm-redis

greymatter delete shared_rules fibonacci
greymatter delete listener fibonacci
greymatter delete listener fibonacci:8080
greymatter delete listener fibonacci:8081
greymatter delete listener fibonacci:10808
greymatter delete listener fibonacci-egress-tcp-to-gm-redis

greymatter delete domain fibonacci
greymatter delete domain fibonacci-egress-tcp-to-gm-redis

greymatter delete cluster fibonacci
greymatter delete cluster fibonacci:8080
greymatter delete cluster fibonacci:8081
greymatter delete cluster fibonacci:10808
greymatter delete cluster fibonacci-to-gm-redis


# send sidecar configuration to Control API
cd ../2_sidecar
greymatter create domain < domain.json
greymatter create listener < listener.json
greymatter create cluster < cluster.json
greymatter create shared_rules < shared_rules.json
greymatter create route < route.json
greymatter create proxy < proxy.json

# send edge configuration to Control API
cd ../3_edge
greymatter create cluster < cluster.json
greymatter create shared_rules < shared_rules.json
greymatter create route < route.json

# configure Catalog entry for new service
cd ../4_catalog
greymatter create catalog-service < entry.json

cd ..
