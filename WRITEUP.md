# Short Write-up

## Tools & Services Used
- **Node.js** – Server-side application development
- **Docker** – Containerization of the application
- **Jenkins** – CI/CD pipeline automation
- **AWS EKS** – Kubernetes-managed service for deployment
- **AWS CLI** – Command-line tool for interacting with AWS
- **kubectl** – Kubernetes command-line tool to manage pods and services
- **AWS CloudWatch** – Monitoring and logging
- **CloudFormation** – Automated creation of VPC and EKS resources
- **Git** – Version control and source code management
- **Docker Hub** – Container registry to store and pull Docker images

## Challenges Faced & Solutions
1. **Docker image deployment to EKS**  
   Solved by building Docker images locally, pushing them to Docker Hub, and using the Jenkins pipeline with proper Docker Hub credentials so EKS pods could pull the images automatically.

2. **Jenkins pipeline configuration**  
   Solved by creating a pipeline that clones the repository, builds the Docker image, pushes it to Docker Hub, and deploys it to EKS. Credentials for Docker Hub and AWS were securely added to Jenkins for authentication.

3. **EKS setup**  
   Solved by creating a dedicated VPC using CloudFormation, launching the EKS cluster, configuring AWS CLI on EC2, and updating kubeconfig to connect to the cluster for deployments.

## Possible Improvements
- If given more time, I could implement the deployment more efficiently and optimize the pipeline for faster builds and automated monitoring.
- Add automated rollback in case of deployment failure.
- Add automated testing before deployment.
- Integrate Slack or email notifications for Jenkins pipeline stages.
- Enhance monitoring with custom CloudWatch dashboards and alarms.
