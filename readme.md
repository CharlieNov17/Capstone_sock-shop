# Altschool Capstone Project

## Deploying the Sock Shop Microservices Application on Kubernetes

This project showcases the deployment of the Sock Shop application on a Kubernetes cluster using an Infrastructure as Code (IaC) approach. It involves provisioning the necessary AWS infrastructure using Terraform, setting up a deployment pipeline, monitoring the application's performance and health, and securing the application.

Key tools and technologies used include Terraform for infrastructure provisioning, GitHub Actions for the deployment pipeline, Kubernetes for container orchestration, and Prometheus for monitoring.

### Project Requirements
- Terraform
- AWS account
- Kubernetes
- Prometheus and Grafana for monitoring
- Let's Encrypt for securing the application
- Helm for package management

### Prerequisites
- An AWS Account
- Terraform installed locally
- GitHub Actions configured
- Kubernetes cluster (EKS)
- Prometheus for monitoring
- The Sock Shop application

### Project Resources
- **Sock Shop Resources:** [Microservices Demo](https://github.com/microservices-demo/microservices-demo.github.io)
- **Demo:** [Microservices Demo](https://github.com/microservices-demo/microservices-demo/tree/master)

## Project Implementation

### 1. Provisioning Infrastructure
The first step is to provision the necessary infrastructure on AWS, including a VPC, security group, and an EKS cluster. To do this, ensure Terraform is installed, and the AWS CLI is configured.

- Initialize Terraform:
  ```bash
  terraform init
  ```

- Check the plan of your infrastructure:
  ```bash
  terraform plan
  ```

- Validate the Terraform code:
  ```bash
  terraform validate
  ```

- Apply the Terraform configuration to provision the infrastructure:
  ```bash
  terraform apply --auto-approve
  ```

![Infrastructure Provision Success](/sockshop/creating%20infrastructure.png)

### 2. Connecting Kubernetes to EKS Cluster
Once the infrastructure is provisioned, update your `kubeconfig` file to connect `kubectl` to the EKS cluster:

```bash
aws eks update-kubeconfig --region us-east-1 --name sock-shop
```
![Kubeconfig Update](/sockshop/kubeconfig.png)

### 3. Deploying the Kubernetes Manifest
Deploy the Kubernetes manifest to the EKS cluster:

```bash
kubectl apply -f deployment.yml
```
![Deploying Manifest](/sockshop/namspaces.png)

- Verify that the pods and services are running:
  ```bash
  kubectl get pods -n sock-shop
  kubectl get svc -n sock-shop
  ```
![Pods and Services](/sockshop/pods.png)
![Pods and Services](/sockshop/services.png)

### 4. Setting Up Ingress Controller
Since the services are not accessible externally, you need to set up an Ingress Controller to create a load balancer:

- Apply the Ingress Controller:
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/aws/deploy.yaml
  ```
![Ingress Controller Install](/sockshop/ingress%20controller%20install.png)
![Load Balancer in UI](/sockshop/load%20balancer.png)

- Apply the Ingress resource:
  ```bash
  kubectl apply -f ingress.yml -n sock-shop
  ```

If the load balancer IP or DNS name doesn’t serve the application, connect it to a domain name with an A record linked to the load balancer's IP address:

```bash
nslookup <DNS name of the load balancer>
```
![Front End of Sock Shop](/sockshop/testpage.png)

## Monitoring

Prometheus is used to monitor the Sock Shop application's performance, including metrics like request latency, error rate, and request volume. Grafana is used to visualize these metrics.

- Install Helm and add the Prometheus repository:
  ```bash
  curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
  sudo apt-get install apt-transport-https
  sudo apt-get update
  sudo apt-get install helm

  helm repo add prometheus https://prometheus-community.github.io/helm-charts
  ```

- Search and install the Prometheus chart:
  ```bash
  helm search repo prometheus
  helm install prometheus prometheus/kube-prometheus-stack -n sock-shop
  ```

- Update the `ingress.yml` file to host Prometheus, Grafana, and Alert Manager, and apply it.

![Prometheus UI](/sockshop/promethus.png))
![Grafana Page](/sockshop/graphana.png)
![Alert Manager Page](/sockshop/alerrtmanager.png)
![Grafana Dashboard](/sockshop/dasboards%20for%20services.png)

## Security

Secure the application with HTTPS using a Let's Encrypt certificate.

- Create a namespace for cert-manager:
  ```bash
  kubectl create namespace cert-manager
  ```

- Apply the cert-manager YAML file:
  ```bash
  kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.2/cert-manager.yaml
  ```
![Cert-Manager Install](/sockshop/certificate%20manager%20installation.png)

- Create and apply the ClusterIssuer and Certificate YAML files to issue the SSL certificate. Update the ingress file with the TLS record and annotations.


## CI/CD Pipeline

CI/CD automates the process of integrating code changes and deploying them to production. This project uses GitHub Actions to automate both infrastructure provisioning and application deployment.

- The CI/CD pipeline is broken into two branches: one for infrastructure provisioning and another for deploying the Kubernetes manifest.

![Terraform Workflow](/sockshop/terafoorm%20cicd.png)
![Manifest Workflow](/sockshop/manifest%20cicd.png)

## Conclusion

This project demonstrates the deployment of a microservices application using best practices in DevOps. By the end, you'll have experience with infrastructure provisioning using Terraform, Kubernetes orchestration, security with HTTPS, monitoring with Prometheus and Grafana, and automated CI/CD pipelines.