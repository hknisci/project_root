# Node.js Express Application Deployment with Kubernetes and ArgoCD

This document outlines the approach taken to deploy a Node.js Express application on a Kubernetes cluster using Docker, Helm, and ArgoCD. The project includes automated CI/CD processes, Slack notifications, and updates using ArgoCD Image Updater.

## Project Overview

The primary objective of this project is to deploy and manage a Node.js Express application on a Kubernetes environment using modern DevOps practices. The deployment process is automated with ArgoCD, ensuring that the application is always up-to-date with the latest Docker image. Additionally, Slack notifications are integrated to provide real-time feedback on application deployment status.

## Technologies Used

- **Kubernetes**: For container orchestration.
- **Docker**: For containerizing the Node.js application.
- **ArgoCD**: For managing the deployment of the application.
- **Helm**: For packaging and deploying the application using Kubernetes manifests.
- **Kustomize**: For managing different environments (e.g., development, staging, production).
- **Slack**: For real-time notifications on application deployment status.
## Steps and Solutions

### 1. Dockerizing the Node.js Express Application

The application is containerized using Docker. A `Dockerfile` is created to define the environment and dependencies required for the application to run.

**Dockerfile:**
```Dockerfile
# Use Node.js base image
FROM node:14

# Set working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY nodejs-express-mysql/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY nodejs-express-mysql/ ./

# Expose port 3000
EXPOSE 3000

# Command to start the application
CMD ["node", "server.js"]
```

### 2. Deploying the Application on Kubernetes

The application is deployed on a Kubernetes cluster using Helm charts and Kustomize configurations. Helm is used to package the Kubernetes manifests, and Kustomize is utilized for managing different deployment environments.

### 3. Setting Up ArgoCD for CI/CD

ArgoCD is configured to manage the continuous integration and deployment of the application. The application’s Kubernetes manifests are stored in a Git repository, and ArgoCD is configured to automatically deploy changes from this repository.

**ArgoCD Application Manifest:**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nodejs-express-mysql
  namespace: argocd
spec:
  project: default
  source:
    repoURL: 'https://github.com/hknisci/project_root'
    targetRevision: HEAD
    path: .
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: prod
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
  imageUpdater:
    annotations:
      argocd-image-updater.argoproj.io/image-list: myregistry/nodejs-express-mysql
```

### 4. Integrating Slack Notifications

Slack notifications are set up to alert the team about the status of deployments. A Slack Webhook URL is created and stored as a Kubernetes secret, which is then referenced in the ArgoCD configuration.

**Slack Notification ConfigMap:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
  namespace: argocd
data:
  config.yaml: |
    subscriptions:
      - recipients:
          - slack:your-channel-name
    context:
      slack:
        token:
          secretKeyRef:
            name: slack-webhook-secret
            key: webhook-url
    triggers:
      on-sync-succeeded:
        - description: Application sync succeeded.
          send:
            - slack
```

### 5. Automatic Docker Image Updates with ArgoCD Image Updater

ArgoCD Image Updater is configured to automatically detect new Docker images pushed to the registry and update the application in the Kubernetes cluster.

### 6. Configuring for Application Access

Windows Firewall is configured to allow external access to the application running on Kubernetes. The necessary ports are opened to ensure that the application is accessible from outside the Kubernetes cluster.

**Kubernetes Service Manifest (NodePort):**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nodejs-express-mysql
  namespace: prod
spec:
  type: NodePort
  selector:
    app: nodejs-express-mysql
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
      nodePort: 30080
```

## Conclusion

This project demonstrates a complete CI/CD pipeline for a Node.js Express application deployed on Kubernetes using Docker, Helm, and ArgoCD. The integration with Slack and ArgoCD Image Updater ensures that the application is always up-to-date and that the team is informed of the deployment status in real-time. Windows Firewall is configured to secure access to the application.

This approach provides a robust and scalable solution for managing modern cloud-native applications in a Kubernetes environment.

## Files and Manifests

- **Dockerfile**: Defines the Docker image for the application.
- **ArgoCD Application Manifest**: Configures ArgoCD to manage the deployment.
- **Slack Notification ConfigMap**: Sets up Slack notifications for deployment status.
- **Kubernetes Service Manifest**: Defines how the application is exposed to external traffic.
