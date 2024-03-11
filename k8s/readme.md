# Karpenter Deployment on a Kubernetes Cluster


For this task, we used a MERN-ecommerce application, composed of three microservices (Frontend, Backend, and MongoDB). To integrate the steps for configuring the Karpenter provisioner, correctly specify necessary IAM roles and policies for AWS, deploy the cluster with `eksctl`, and use SCRAM for MongoDB authentication.

### Step-by-Step Guide with Karpenter on AWS

#### 1. Install eksctl and AWS CLI
Begin by ensuring eksctl and the AWS CLI are installed on your system. These tools are essential for creating the EKS cluster and interacting with AWS services.
We Installed [eksctl](https://eksctl.io/installation/)

#### 2. Create the EKS Cluster
After installing eksctl, proceed with the cluster creation script `create-cluster.sh`. This script automates the EKS cluster setup and configures necessary IAM roles and policies for Karpenter.

#### 3. Install [Karpenter]( https://karpenter.sh/docs/getting-started/getting-started-with-karpenter/)
Once the cluster is up, use the Karpenter installation script `install-karpenter.sh` to deploy Karpenter into the cluster. This sets the stage for efficient and responsive scaling based on the application's demands.

#### 4. Deploy the MERN eCommerce Application
With the cluster and Karpenter ready, it's time to deploy the MERN eCommerce application. This involves several key steps:
* Deploy MongoDB: Apply the MongoDB deployment configuration. Ensure that MongoDB is set up with SCRAM authentication for security.
* Deploy Backend and Frontend Services: Apply Kubernetes deployment manifests for both the backend and frontend components of the eCommerce application. These manifests should define the desired state of the application, including the number of replicas, resource requests and limits, and the Docker images to use.
* Configure Services: Apply Kubernetes service manifests to expose the backend and frontend services. For the frontend, a LoadBalancer service type can be used to expose the service to the internet. For the backend, a ClusterIP service type suffices, as it only needs to be accessible within the cluster.

```shell
kubectl apply -f backend-deployment.yml
kubectl apply -f frontend-deployment.yml
kubectl apply -f mongodb.yml
```

#### 4. Ensure SCRAM Authentication for MongoDB
MongoDB uses [SCRAM](https://www.mongodb.com/docs/manual/core/security-scram/)  (Salted Challenge Response Authentication Mechanism) for authentication, enhancing security. It's configured in the MongoDB deployment YAML.

#### 5. Configure NodePools and EC2NodeClass
Now that the application is deployed, configure Karpenter to make informed decisions on node provisioning according to the application's needs. Apply the `config.yml` file to define NodePool and EC2NodeClass, specifying requirements like instance types and sizes.

#### 6. CloudFormation Template for IAM Setup
Throughout this process, the CloudFormation template `cloudformation.yml` is used to ensure Karpenter and cluster nodes have the appropriate permissions to operate within the AWS environment.

#### 7. Monitor and Scale
With the application running, Karpenter will monitor resource utilization and automatically adjust the number of nodes in the cluster based on demand. This ensures the application scales efficiently, maintaining performance while optimizing costs.

![Autoscaling in action](<img/Screen Shot 2024-03-04 at 12.56.24.png>)

![Karpenter restarting new pods after some were terminated manually](<img/Screen Shot 2024-03-04 at 13.01.26.png>)

#### 8. Cleanup Resources
When the environment is no longer needed, or you're ready to deploy a new version, use the cleanup script `cleanup.sh` to remove all resources. This includes the EKS cluster, IAM roles, EC2 instances, and any other AWS resources provisioned during the setup and deployment process.

<i> Note: You would find all scripts and yml files mentioned above in the directory </i>

### Conclusion
Following these steps, you set up a Kubernetes cluster with a MERN-stack eCommerce application and Karpenter for autoscaling, ensuring instances are provisioned efficiently according to your application's needs. By specifying detailed requirements and limits in the Karpenter provisioner configuration and setting up the necessary IAM roles and policies, you guide Karpenter to make informed provisioning decisions, optimizing resource usage and cost.


#### Resources
- https://github.com/mongodb/mongodb-kubernetes-operator/blob/master/docs/resize-pvc.md
- https://medium.com/@tanmaybhandge/mongodb-from-basics-to-deployment-on-kubernetes-c1ced7143a6c