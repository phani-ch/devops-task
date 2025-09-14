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
├── package-lock.json            # Dependency versions
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
