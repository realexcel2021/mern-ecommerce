#!/bin/bash

# supposed you used terraform to spin up karpenter

CLUSTER_NAME="ecommerce-project-cluster"

KARPENTER_NAMESPACE="kube-system"
KARPENTER_VERSION="0.35.0"
K8S_VERSION="1.29"

 

# Logout of helm registry to perform an unauthenticated pull against the public ECR
# helm registry logout public.ecr.aws

helm upgrade --install karpenter oci://public.ecr.aws/karpenter/karpenter --version "${KARPENTER_VERSION}" --namespace "${KARPENTER_NAMESPACE}" --create-namespace \
  --set "settings.clusterName=${CLUSTER_NAME}" \
  --set "settings.interruptionQueue=${CLUSTER_NAME}" \
  --set controller.resources.requests.cpu=1 \
  --set controller.resources.requests.memory=1Gi \
  --set controller.resources.limits.cpu=1 \
  --set controller.resources.limits.memory=1Gi \
  --wait --debug

