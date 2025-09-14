# Logo Server

A simple Express.js web server that serves the Swayatt logo image.

## What is this app?

This is a lightweight Node.js application built with Express.js that serves a single logo image (`logoswayatt.png`) when accessed through a web browser. When you visit the root URL, the server responds by displaying the Swayatt logo.

## Prerequisites

- Node.js (version 12 or higher)
- npm (Node Package Manager)

## Installation

1. Clone or download this repository
2. Navigate to the project directory:
   ```bash
   cd "devops task"
   ```
3. Install dependencies:
   ```bash
   npm install
   ```

## How to Start the App

Run the following command:
```bash
npm start
```

The server will start and display:
```
Server running on http://localhost:3000
```

## Usage

Once the server is running, open your web browser and navigate to:
```
http://localhost:3000
```

You will see the Swayatt logo displayed in your browser.

## Project Structure

```
├── app.js                   # Main server file
├── package.json             # Project dependencies and scripts
├── package-lock.json        # Dependency versions
├── logoswayatt.png          # Logo image file
├── README.md                # Project documentation
├── .gitignore               # Ignores node_modules, logs, etc.
├── Jenkinsfile              # Jenkins pipeline definition
├── Dockerfile               # Docker configuration
├── deployment.yaml          # EKS Deployment and Service
├── cloudformation_templete  # CloudFormation templates
├──deployment-proof/         # Deployment evidence
   ├── deployment-proof-1.png                    # deployment screenshot 2
   ├── deployment-proof-2.png                    # deployment screenshot 2
   └──deployment-proof-jenkins-stages.mp4        # Video demo
```

## Technical Details

- **Framework**: Express.js
- **Port**: 3000
- **Endpoint**: GET `/` - serves the logo image
- **File served**: `logoswayatt.png`

## Automate Jenkins Pipeline: Clone, Build, Push, and Deploy to EKS

### Jenkins Pipeline Overview

This pipeline automates the following tasks:

- Clone code from GitHub repository
- Build Docker image
- Push Docker image to Docker Hub
- Deploy the application to Amazon EKS cluster
# Setup Guide
## Required Tools

- **Git** – To clone the repository
- **Docker** – To build and run Docker images
- **Jenkins** – To automate the pipeline
- **AWS CLI** – To interact with AWS and EKS
- **kubectl** – To manage Kubernetes/EKS cluster
- **AWS Account** – With IAM roles for EKS, CloudWatch, and Docker registry access
- **Docker Hub Account** – To push Docker images
- **CloudFormation** – For automated EKS and VPC setup

## Jenkins Setup

Install Jenkins on your server (Ubuntu/AWS EC2).  

### Install Required Plugins
- Git Plugin  
- Pipeline Plugin  
- Kubernetes CLI Plugin  
- Docker Plugin  

### Create Pipeline Job in Jenkins
- Pipeline from SCM → Git  
- Repository URL: `https://github.com/phani-ch/devops-task.git`  
- Branch: `dev`  

### Add Jenkins Credentials
- **Docker Hub:** `dockerhub-creds` (Username: `user_name`, Password: `your_password`)  
- **AWS IAM:** `aws-eks-credentials` (Access Key / Secret Key)
## Docker Setup

Docker is required to build and run containerized applications.

```bash
# Update and install Docker
sudo apt update
sudo apt install docker.io -y

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add current user and Jenkins user to Docker group
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins

# Log out and log back in for group changes to take effect

# Verify Docker installation
docker --version
docker run hello-world

# Build and run Docker image locally (optional)
docker build -t user_name/image_name:1 .
docker run -p 3000:3000 user_name/image_name:1
 ```
# EKS Setup

### 1) Create IAM Role for EKS with required policies:
- AmazonEKSClusterPolicy for cluster
 - AmazonEKSWorkerNodePolicy, AmazonEC2ContainerRegistryReadOnly, AmazonEKS_CNI_Policy for nodes
 (Create role via AWS Console or CLI and attach policies)

### 2) Create dedicated VPC for EKS cluster using CloudFormation
aws cloudformation create-stack --stack-name eks-vpc-stack \
--template-url https://amazon-eks.s3.us-west-2.amazonaws.com/cloudformation/2020-08-12/amazon-eks-vpc-private-subnets.yaml \
--capabilities CAPABILITY_IAM

### 3) Create EKS cluster using CloudFormation
 (Use your own cluster template or CloudFormation stack)

### 4) Launch an EC2 instance
 (Choose Ubuntu or preferred AMI with necessary access)

### 5) Install AWS CLI on EC2 instance
 ```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
 ```

### 6) Configure AWS CLI
aws configure
### Enter AWS Access Key, Secret Key, Default Region (e.g., us-east-1), output format (json)

### 7) Update kubeconfig to connect to EKS
 ```
aws eks update-kubeconfig --name eks-cluster --region us-east-1
kubectl get nodes
 ```

### CloudWatch Monitoring Setup
 ```
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb && sudo dpkg -i -E ./amazon-cloudwatch-agent.deb && sudo tee /opt/aws/amazon-cloudwatch-agent/bin/config.json > /dev/null <<'EOL'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}"
    },
    "metrics_collected": {
      "cpu": {
        "measurement": ["usage_system","usage_user","usage_idle"],
        "metrics_collection_interval": 60
      },
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": ["used_percent"],
        "metrics_collection_interval": 60,
        "resources": ["*"]
      }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {"file_path":"/var/log/syslog","log_group_name":"jenkins-ec2-syslog","log_stream_name":"{instance_id}"},
          {"file_path":"/var/log/jenkins/jenkins.log","log_group_name":"jenkins-logs","log_stream_name":"{instance_id}"}
        ]
      }
    }
  }
}
EOL
 ```
### Start CloudWatch Agent and verify
 ```
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s && /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status

 ```
