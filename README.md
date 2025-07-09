# AWS Lambda S3 Notification 

## 📌 Project Overview

This project demonstrates a fully automated serverless application deployed using **Terraform** and **GitHub Actions**. It includes:

- Provisioning an **S3 bucket** and uploading local files from `sample_files/`
- Creating an **SNS topic** with an **email subscription**
- Deploying a **Lambda function** that:
  - Lists objects in the S3 bucket
  - Sends the file list via email through SNS
  - Can be triggered manually (CLI) or automatically (on S3 upload)

---

## 🗂️ Project Structure

```
.
├── README.md
├── backend.tf
├── lambda_function.py
├── lambda_function_payload.zip
├── lambda_test.sh
├── main.tf
├── requirements
├── response.json
├── sample_files/
│   ├── dummy_test
│   .
│   .
│   └── test files
├── terraform.tfstate
└── terraform.tfstate.backup                
```
```
![Architecture Diagram](https://github.com/Fadi7AY/DevOps_Assignment/blob/remote_s3/IaC.jpg?raw=true)
```

## 📋 Requirements

Make sure to install Python dependencies for the Lambda function and manual test:

### 1. Create and activate a virtual environment

```bash
python3 -m venv .venv
source .venv/bin/activate  # On Windows use: .venv\Scripts\activate
```

### 2. Install boto3 (for both local test and Lambda packaging)

```bash
pip install boto3
```
---

## 🚀 Deployment Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/Fadi7AY/DevOps_Assignment
cd DevOps_Assignment
```

### 2. Configure AWS Credentials

Ensure your AWS credentials are configured either through:

- `aws configure`  
- Or by exporting them as environment variables in GitHub Actions:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

### 3. Deploy with Terraform Locally

```bash
terraform init
terraform apply
```

### 4. Deploy with GitHub Actions (CI/CD)

- Go to the **Actions** tab in your GitHub repo
- Select the workflow and click **Run workflow** to deploy infrastructure

### 5. Confirm Your Email

⚠️ **IMPORTANT:**  
After the first deployment, you will receive a confirmation email from AWS SNS.  
You **must click the confirmation link** to activate the email subscription.  
Otherwise, SNS notifications will not be delivered.

---

## 🧪 Manually Test Lambda

Use the provided shell script to invoke the Lambda function:

```bash
./lambda_test.sh
cat response.json
```

---

## 🛠 Tools Used

- **Terraform** – Infrastructure as Code
- **GitHub Actions** – CI/CD pipeline
- **AWS Lambda** – Serverless compute
- **AWS S3** – Object storage
- **AWS SNS** – Notification service
- **AWS IAM** – Access control



