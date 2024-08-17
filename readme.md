### Altschool Capstone Project: Deployment of the Socks Shop Microservices Application on Kubernetes

This project focuses on deploying the Socks Shop application on a Kubernetes cluster using Infrastructure as Code (IaC). The process includes provisioning the necessary infrastructure on AWS with Terraform, setting up a deployment pipeline, monitoring the application’s performance and health, and ensuring security.

**Tools and Technologies Used:**

- **Terraform:** For provisioning infrastructure on AWS.
- **GitHub Actions:** For automating the deployment pipeline.
- **Kubernetes:** For container orchestration.
- **Prometheus and Grafana:** For monitoring and visualization.
- **Let’s Encrypt:** For securing the application with SSL/TLS certificates.
- **Helm:** For managing Kubernetes packages.

---

### Prerequisites

- AWS Account
- Terraform
- GitHub Actions
- Kubernetes
- Prometheus
- Socks Shop Application

### Project Resources

- **Socks Shop Resources:** [GitHub Repository](https://github.com/microservices-demo/microservices-demo.github.io)
- **Demo:** [Microservices Demo](https://github.com/microservices-demo/microservices-demo/tree/master)

### Project Implementation

#### 1. **Infrastructure Provisioning**

Start by provisioning the necessary infrastructure on AWS, which includes a VPC, Security Group, and EKS Cluster. This can be done using Terraform. The Terraform configuration is available in the `terraform` branch of this repository.

**Steps:**
- Install Terraform and configure the AWS CLI.
- Write the Terraform code for the infrastructure.
- Initialize Terraform with `terraform init`.
- Validate the configuration with `terraform validate`.
- Check the plan with `terraform plan`.
- Apply the configuration with `terraform apply --auto-approve`.

This will set up the required infrastructure on AWS.

#### 2. **Kubernetes Configuration**

Once the infrastructure is provisioned, connect your `kubectl` to the EKS cluster by updating the kubeconfig:

```bash
aws eks update-kubeconfig --region us-east-1 --name sock-shop
```

Deploy the application to the EKS cluster using the Kubernetes manifest files available in the `main` branch of this repository:

```bash
kubectl apply -f deployment.yml
```

Verify the deployment with the following commands:

```bash
kubectl get pods -n sock-shop
kubectl get svc -n sock-shop
```

#### 3. **Load Balancing and Ingress**

Since the services are not accessible due to their ClusterIP, install the Ingress controller to create a load balancer:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/aws/deploy.yaml
```

Next, create and apply an Ingress resource to provide a single point of entry to your cluster:

```bash
kubectl apply -f ingress.yml -n sock-shop
```

To make the application accessible, connect the load balancer to a domain name using an A record.

#### 4. **Monitoring**

Prometheus will monitor the performance and health of the Socks Shop application, while Grafana will be used for visualization.

**Steps:**
- Install Helm and update it.
- Add the Prometheus Helm repository:
  ```bash
  helm repo add prometheus https://prometheus-community.github.io/helm-charts
  ```
- Install the Prometheus stack:
  ```bash
  helm install prometheus prometheus/kube-prometheus-stack -n sock-shop
  ```
- Update the Ingress configuration to host Prometheus, Grafana, and Alertmanager.

#### 5. **Security with HTTPS**

Secure the application using Let’s Encrypt certificates with cert-manager.

**Steps:**
- Create a namespace for cert-manager:
  ```bash
  kubectl create namespace cert-manager
  ```
- Install cert-manager:
  ```bash
  kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.2/cert-manager.yaml
  ```
- Create and apply ClusterIssuer and Certificate YAML files.
- Update the Ingress resource with TLS settings.

#### 6. **CI/CD Pipeline**

CI/CD involves continuous integration and deployment of code. GitHub Actions was used to automate this process.

**Steps:**
- Create two branches: one for infrastructure provisioning and another for application deployment.
- Set up GitHub Actions to automate the deployment pipeline, ensuring that any code passing tests is deployed to staging or production environments.

---

By following these steps, the Socks Shop microservices application will be deployed on Kubernetes using a fully automated, secure, and scalable approach.