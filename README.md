# Example Repository: Deploy Flask App to OpenShift with ArgoCD

This is a template repository demonstrating how to deploy a containerized Python application to OpenShift using ArgoCD for GitOps-based continuous deployment.

## 📋 Prerequisites

Before deploying this application, ensure you have:

1. **OpenShift Cluster Access**
   - Access to an OpenShift cluster with ArgoCD already configured
   - `oc` CLI installed and configured

2. **DNS Name Registration**
   - Contact itsansible to register your desired DNS name
   - Update `openshift/ingress.yaml` with your registered DNS name

3. **AppProject Setup** (Request via Topdesk to ITS Linux)
   - Namespace where you'll deploy the application
   - Your repository Git URL
   - OpenShift group with access to the namespace

4. **Private Repository Access** (if your repository is private/internal)
   
   ArgoCD requires credentials to access private repositories. Use a GitHub App:
   
   - Create a GitHub App with read-only access to Contents and Metadata
   - Generate a private key (.pem file)
   - Note the GitHub App ID and Installation ID
   - Create a Kubernetes Secret with the credentials:
     ```yaml
     apiVersion: v1
     kind: Secret
     metadata:
       name: github-app-creds
       namespace: openshift-gitops
       labels:
         argocd.argoproj.io/secret-type: repo-creds
     type: Opaque
     stringData:
       githubAppID: "<GitHub App ID>"
       githubAppInstallationID: "<Installation ID>"
       githubAppPrivateKey: |
         -----BEGIN RSA PRIVATE KEY-----
         <your-private-key-content>
         -----END RSA PRIVATE KEY-----
       url: https://github.com/<organization>
       insecure: "true"
       type: git
       name: github
     ```
   
   - [Seal the Secret](https://docs.cp.its.uu.nl/content/guides/seal-your-secrets/) using your organization's Sealed Secrets process
   - Send the sealed secret to the ITS Linux team for deployment
   
   For full details, see [Private or internal Git repository](https://docs.cp.its.uu.nl/content/guides/managed-deployment-with-argocd/?h=argocd#private-or-internal-git-repository)

```
.
├── app.py                 # Flask application
├── requirements.txt       # Python dependencies
├── Dockerfile            # Container image definition
├── pyproject.toml        # Project configuration
├── openshift/            # OpenShift manifests
│   ├── deployment.yaml   # Deployment configuration
│   ├── service.yaml      # Service definition
│   ├── ingress.yaml      # Ingress configuration
│   ├── configmap.yaml    # Environment variables
│   └── kustomization.yaml
├── argocd/               # ArgoCD configuration
│   ├── application.yaml  # ArgoCD Application definition
│   ├── README.md
│   └── kustomization.yaml
└── kustomization.yaml    # Root Kustomization
```

## 🚀 Quick Start

Simply push your changes to the repository. ArgoCD automatically syncs every 3 minutes and will deploy any changes to your OpenShift cluster.

### Configuration

Before pushing to your repository, update these files:
- `argocd/application.yaml` - Point to your repository URL
- `openshift/deployment.yaml` - Update container registry
- `openshift/ingress.yaml` - Update your domain

Once committed and pushed, ArgoCD will automatically detect and apply the changes.

## 🐳 Building and Pushing the Container Image

Images are built and pushed automatically by GitHub Actions whenever you push to the `main` branch.

### Setup Required

Configure these GitHub repository secrets and variables:
- `HARBOR_REGISTRY` - Your Harbor registry URL (e.g., harbor.example.com)
- `HARBOR_PROJECT` - Harbor project name (e.g., example)
- `HARBOR_IMAGE_NAME` - Image name (e.g., example-app)
- `HARBOR_USERNAME` - Harbor username (secret)
- `HARBOR_PASSWORD` - Harbor password/token (secret)

Once configured:
1. Push changes to `main` branch
2. GitHub Actions automatically builds the Docker image
3. Version is bumped automatically in `pyproject.toml`
4. Image is pushed to Harbor with the new version tag
5. `openshift/deployment.yaml` is updated with the new image tag
6. ArgoCD detects the change and deploys it

## ⚙️ Configuration

### Environment Variables (openshift/configmap.yaml)
- `ENVIRONMENT`: Deployment environment (production, staging, development)
- `APP_VERSION`: Application version

### Container Registry
Update the image reference in `openshift/deployment.yaml`:
```yaml
image: your-registry.io/your-org/example-app:latest
```

### Domain/Hostname
Update the hostname in `openshift/ingress.yaml`:
```yaml
host: your-app.yourdomain.com
```

### ArgoCD Repository
Update the repository URL in `argocd/application.yaml`:
```yaml
repoURL: https://github.com/your-org/your-repo.git
```

## 📍 Accessing the Application

After deployment, the application exposes:
- `/` - Main endpoint (returns JSON with app info)
- `/health` - Health check endpoint
- `/ready` - Readiness probe endpoint

## 🔄 Continuous Deployment with ArgoCD

ArgoCD syncs this repository every 3 minutes. Once you commit and push changes to the `main` branch:
1. ArgoCD will automatically detect the changes
2. Deploy the new configuration to your OpenShift cluster
3. Check the ArgoCD UI for sync status and deployment history

No manual `oc apply` commands needed!

## 📝 Development

### Local Testing

1. Create a Python virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Run the application:
   ```bash
   python app.py
   ```

4. Test the endpoints:
   ```bash
   curl http://localhost:8000/
   curl http://localhost:8000/health
   curl http://localhost:8000/ready
   ```

### Adding Dependencies

1. Install in your virtual environment:
   ```bash
   pip install new-package
   ```

2. Add to `requirements.txt`:
   ```bash
   pip freeze > requirements.txt
   ```

3. Rebuild and push the Docker image


## 📚 Resources

- [UU Cloud Platforms Documentation](https://docs.cp.its.uu.nl)
- [OpenShift Documentation](https://docs.openshift.com)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io)
- [Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [Kustomize](https://kustomize.io/)

## 📄 License

This example is provided as-is for educational purposes.
