# MLOps environment setup (AWS + Kubernetes)

This repo provisions a small Kubernetes environment on AWS using Terraform, then you can install:
- NVIDIA **KAI Scheduler**
- **MLflow**
- run:ai **fake-gpu-operator**
- **Kubeflow** (last; heavy)
- **Prometheus + Grafana**

## Cost/credit-saving defaults (important)

- **NAT Gateway is disabled** (NAT is an “always-on” hourly cost). Nodes + cluster use **public subnets** by default.
- **Node group defaults to 1 small node** in `dev` (`desired_size=min_size=max_size=1`).
- Avoid `Service type: LoadBalancer` and ALB Ingress while learning (each can create AWS LBs that cost money).
  - The file `demo-ingress.yaml` is an **ALB ingress example**—don’t apply it unless you intentionally want an ALB.
- When you’re done for the day, run `terraform destroy` to stop all costs.

## 1) Provision the dev cluster (Terraform)

From repo root:

```bash
cd environments/dev

# create your own tfvars (do NOT commit it)
cp terraform.tfvars.example terraform.tfvars

terraform init
terraform plan
terraform apply
```

Note: **EKS requires subnets in at least two different AZs**. The provided `terraform.tfvars.example` includes 2 public subnets for this reason.

## 2) Connect `kubectl` to EKS

```bash
aws eks update-kubeconfig --region <region> --name <cluster_name>
kubectl get nodes -o wide
```

## Recommended install order (do this first → last)

1. **Prometheus + Grafana** (so you can observe everything else)
2. **fake-gpu-operator** (simulate GPUs on CPU nodes)
3. **KAI Scheduler**
4. **MLflow** (Kubernetes-focused course)
5. **Kubeflow** (expect to scale up nodes)

## 3) Install Prometheus + Grafana

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade -i monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace \
  --set grafana.service.type=ClusterIP \
  --set prometheus.service.type=ClusterIP \
  --set alertmanager.service.type=ClusterIP
```

Access Grafana (no AWS LoadBalancer; uses port-forward):

```bash
kubectl -n monitoring port-forward svc/monitoring-grafana 3000:80
kubectl -n monitoring get secret monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d; echo
```

Then open `http://localhost:3000` (user: `admin`).

## 4) Install fake GPU operator (run:ai)

Pick a node name:

```bash
kubectl get nodes
kubectl label node <node-name> run.ai/simulated-gpu-node-pool=default
```

Install (choose a release from `run-ai/fake-gpu-operator`):

```bash
helm upgrade -i gpu-operator oci://ghcr.io/run-ai/fake-gpu-operator/fake-gpu-operator \
  --namespace gpu-operator --create-namespace \
  --version <VERSION>
```

## 5) Install NVIDIA KAI Scheduler

Install (choose a release from `NVIDIA/KAI-Scheduler`):

```bash
helm upgrade -i kai-scheduler oci://ghcr.io/nvidia/kai-scheduler/kai-scheduler \
  -n kai-scheduler --create-namespace \
  --version <VERSION>
```

## 6) Install MLflow (Helm)

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm upgrade -i mlflow bitnami/mlflow -n mlflow --create-namespace \
  --set service.type=ClusterIP
kubectl -n mlflow port-forward svc/mlflow 5000:80
```

Open `http://localhost:5000`.

## 7) Install Kubeflow (do last)

Kubeflow is **resource-heavy**. Before you try it, plan to:
- temporarily **scale up** node resources (bigger instance type and/or more nodes)
- keep all services **ClusterIP** and use port-forward to avoid AWS load balancers

Start from the Kubeflow manifests release notes and pick a **Kubeflow release that supports your Kubernetes version**:
- `kubeflow/manifests` (stable releases): https://github.com/kubeflow/manifests/releases

## Tear down (stop charges)

```bash
cd environments/dev
terraform destroy
```
