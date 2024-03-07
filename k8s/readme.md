# Karpenter Deployment on a Kubernetes Cluster


For this task, we used a MERN-ecommerce application, composed of three microservices (Frontend, Backend, and MongoDB). To integrate the steps for configuring the Karpenter provisioner, correctly specify necessary IAM roles and policies for AWS, deploy the cluster with `eksctl`, and use SCRAM for MongoDB authentication.

### Step-by-Step Guide with Karpenter on AWS

### 1. Prepare the Kubernetes Cluster
To deploy the Kubernetes Cluster, we used eksctl (a simple CLI tool for creating clusters on EKS, which automates much of the process).  EKS (Amazon Elastic Kubernetes Service) was used for seamless integration with Karpenter. 
- We Installed eksctl https://eksctl.io/installation/

- Create the cluster using

```shell
eksctl create cluster 
--name your-cluster-name 
--region your-region 
--nodegroup-name standard-workers 
--node-type t3.medium 
--nodes 3 
--nodes-min 1 
--nodes-max 4
```
Note: Replace (name your-cluster-name) and (your-region) where appropriate


### 2. Deploy the MERN-stack Application
Deploy your microservices (backend, frontend, MongoDB) by applying their respective Kubernetes manifests:

```shell
kubectl apply -f backend-deployment.yml
kubectl apply -f frontend-deployment.yml
kubectl apply -f backend-service.yml
kubectl apply -f frontend-service.yml
kubectl apply -f mongodb.yml
```

#### 3. Ensure SCRAM Authentication for MongoDB
MongoDB uses [SCRAM](https://www.mongodb.com/docs/manual/core/security-scram/)  (Salted Challenge Response Authentication Mechanism) for authentication, enhancing security. It's configured in the MongoDB deployment YAML.

#### 4. Install [Karpenter]( https://karpenter.sh/docs/getting-started/getting-started-with-karpenter/) on Your Cluster, following the step by step process 

<i>We forgot to configure the Karpenter provisioner before triggering the autoscaler, and it led to the creation of instances with higher memory than necessary, this suggests that Karpenter might have made decisions based on the default settings or the existing workload demands without specific guidance on the types or sizes of instances to provision.</i>

#### 5. Trigger Autoscaling and Monitor
With Karpenter installed and configured, and the IAM roles and policies in place, your cluster is ready to autoscale. Monitor Karpenter's activity and the instances it provisions to ensure they match your application's requirements and the specified limits.

![Autoscaling in action](<img/Screen Shot 2024-03-04 at 12.56.24.png>)

![Karpenter restarting new pods after some were terminated manually](<img/Screen Shot 2024-03-04 at 13.01.26.png>)

#### 6. Monitoring Karpenter's Activity
Keep an eye on Karpenter's decisions and the resources of your Kubernetes cluster:

```shell
kubectl logs -f -n karpenter $(kubectl get pods -n karpenter -l app=karpenter -o name)
kubectl get nodes
kubectl get pods
```
#### 7. Delete the cluster
To avoid additional charges, remove the demo infrastructure from your AWS account.

```shell
helm uninstall karpenter --namespace "${KARPENTER_NAMESPACE}"
aws cloudformation delete-stack --stack-name "Karpenter-${CLUSTER_NAME}"
aws ec2 describe-launch-templates --filters "Name=tag:karpenter.k8s.aws/cluster,Values=${CLUSTER_NAME}" |
    jq -r ".LaunchTemplates[].LaunchTemplateName" |
    xargs -I{} aws ec2 delete-launch-template --launch-template-name {}
eksctl delete cluster --name "${CLUSTER_NAME}"
```

### Conclusion
Following these steps, you set up a Kubernetes cluster with a MERN-stack eCommerce application and Karpenter for autoscaling, ensuring instances are provisioned efficiently according to your application's needs. By specifying detailed requirements and limits in the Karpenter provisioner configuration and setting up the necessary IAM roles and policies, you guide Karpenter to make informed provisioning decisions, optimizing resource usage and cost.


#### Resources
- https://github.com/mongodb/mongodb-kubernetes-operator/blob/master/docs/resize-pvc.md
- https://medium.com/@tanmaybhandge/mongodb-from-basics-to-deployment-on-kubernetes-c1ced7143a6c