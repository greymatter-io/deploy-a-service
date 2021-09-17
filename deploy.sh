#!/bin/bash
set -x

cd $(dirname "${BASH_SOURCE[0]}")

# configure greymatter CLI to communicate with Control API
source ./env

# deploy to Kubernetes
cd 1_kubernetes
kubectl apply -f deployment.yaml

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
