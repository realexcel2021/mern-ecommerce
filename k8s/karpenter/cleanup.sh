#!/bin/bash

CLUSTER_NAME="ecommerce-project-cluster"

KARPENTER_NAMESPACE="kube-system"
KARPENTER_VERSION="0.35.0"
K8S_VERSION="1.29"

AWS_PARTITION="aws" # if you are not using standard partitions, you may need to configure to aws-cn / aws-us-gov
AWS_DEFAULT_REGION="us-east-1"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"


helm uninstall karpenter --namespace "${KARPENTER_NAMESPACE}"

aws cloudformation delete-stack --stack-name "Karpenter-${CLUSTER_NAME}"

aws ec2 describe-launch-templates --filters "Name=tag:karpenter.k8s.aws/cluster,Values=${CLUSTER_NAME}" |
    jq -r ".LaunchTemplates[].LaunchTemplateName" |
    xargs -I{} aws ec2 delete-launch-template --launch-template-name {}
    
eksctl delete cluster --name "${CLUSTER_NAME}"