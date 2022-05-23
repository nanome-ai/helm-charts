# k8s-poc
Scripts that can be used to deploy a starter stack to a kubernetes cluster

## Deploy Starter Stack
```sh
helm dependencies update nanome/starter-stack
helm install --generate-name nanome/starter-stack
```

## Deploy an individual plugin
```sh
helm dependencies update nanome/plugins/chemical-interactions
helm install --generate-name nanome/plugins/chemical-interactions
```

## Deploy AWS EKS via command line

0. Go to AWS IAM and set up a policy so that EC2s and etc can be launched and managed by EKS
"EKS Cluster service" permissions

1. Install eksctl
```
brew tap weaveworks/tap
brew install weaveworks/tap/eksctl
```

2. Run a basic cluster setup
```
eksctl create cluster \
> --name test-cluster \
> --version 1.21 \
> --region us-west-1 \
> --nodegroup-name linux-nodes \ 
> --node-type t2.small \
> --nodes 2

```
_Note that this just creates a new VPC and subnet, does not use existing subnets and VPCs rip_

Resources
https://eksctl.io/usage/vpc-configuration/

EKSCTL but for all the Cloud providers
https://github.com/kubernetes/kops


## Open Prometheus monitoring
kubectl port-forward --namespace prometheus deployments/prometheus-grafana 3000

user: admin
password: prom-operator