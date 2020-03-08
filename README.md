# example-app
Example application deployed on Kubernetes

## Install the following dependencies first

* https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
* https://kubernetes.io/docs/tasks/tools/install-kubectl/
* https://www.terraform.io/downloads.html 

## Start by creating a user and password for the database

```bash
echo -n '# ADD DB USER' > db_username.txt
echo -n '# ADD DB PASSWORD' > db_password.txt
```

## Create the AWS resorces with terraform

```bash
# Loading user and password in environment for terraform
export TF_VAR_db_username=$(cat db_username.txt)
export TF_VAR_db_password=$(cat db_password.txt)

cd infra/terraform
terraform init
terraform apply
```

## Configure kubectl to use EKS

```bash
aws eks --region eu-west-2 update-kubeconfig --name example
```

## Deploy application to EKS

```bash
# Init kubernetes environment
kubectl apply -f infra/kubernetes/namespace.yml
kubectl apply -f infra/kubernetes/load-balancer.yml

# Create database access secret
kubectl create secret generic db-access --namespace example --from-literal=username=$(cat db_username.txt) --from-literal=password=$(cat db_password.txt) --from-literal=address=$(cd infra/terraform && terraform output db-address)

# Deploy application
kubectl apply -f infra/kubernetes/application.yml

# Get application endpoint for access
kubectl get svc example
```
