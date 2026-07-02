# ArgoCD Application Deployment

This is an example repository demonstrating how to deploy a Python Flask application to OpenShift using ArgoCD.

## Quick Start

### Prerequisites
- OpenShift cluster with ArgoCD installed
- `oc` CLI (OpenShift Command Line Interface)
- kubectl or oc CLI access to your cluster

### Deploy the application

1. **Login to OpenShift**
   ```bash
   oc login https://your-cluster-url --token=<your-token>
   ```

2. **Create ArgoCD Application**
   ```bash
   oc apply -k argocd
   ```

3. **Monitor the deployment**
   ```bash
   oc get applications -n argocd
   oc describe application example-app -n argocd
   ```

### Manual deployment (without ArgoCD)

If you don't have ArgoCD set up, you can deploy directly:
```bash
oc apply -k openshift
```

## What's Included

- **app.py** - Simple Flask application with health check endpoints
- **requirements.txt** - Python dependencies
- **Dockerfile** - Container image definition
- **openshift/** - OpenShift deployment manifests
  - deployment.yaml - Application deployment configuration
  - service.yaml - Service definition
  - ingress.yaml - Ingress configuration
  - configmap.yaml - Environment variables
- **argocd/** - ArgoCD Application definition for GitOps deployment

## Customization

Before deploying to your cluster:

1. Update the image registry in `openshift/deployment.yaml`
2. Change the hostname in `openshift/ingress.yaml` to your domain
3. Update the repository URL in `argocd/application.yaml`
4. Modify environment variables in `openshift/configmap.yaml`

## Building the Docker Image

```bash
docker build -t your-registry/example-app:latest .
docker push your-registry/example-app:latest
```

