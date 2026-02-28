![Terraform Validation](https://github.com/ThireshL/terraform_iac/actions/workflows/terraform-check.yml/badge.svg)
![Terraform Version](https://img.shields.io/badge/Terraform-1.5+-623CE4?logo=terraform)
![AWS Provider](https://img.shields.io/badge/AWS_Provider-~%3E5.0-FF9900?logo=amazon-aws)
![GCP Provider](https://img.shields.io/badge/GCP_Provider-~%3E5.0-4285F4?logo=google-cloud)
![Azure Provider](https://img.shields.io/badge/Azure_Provider-~%3E4.0-0089D6?logo=microsoft-azure)
# Multi-Cloud Data Engineering Infrastructure (IaC)

This repository is an Enterprise-Grade Infrastructure-as-Code (IaC) Framework centered on a high-depth AWS ecosystem, with specialized GCP and Azure integrations for cross-cloud interoperability. It serves as a professional setup for advanced Terraform patterns, implementing industry-standard DevOps practices.

## 🏗️ Architecture Overview

The infrastructure is designed for **Scalability**, **Security**, and **Collaboration**. By utilizing Terraform, we ensure that the environment is version-controlled and reproducible across different cloud providers.

### Current Cloud Providers:
* **AWS (Amazon Web Services):** Primary storage and identity management.
* **GCP (Google Cloud Platform):** Data warehousing (BigQuery) and cross-cloud query execution.
* **Azure:** Secondary cloud storage and high-availability Remote State management

### Key Infrastructure Pillars:
* **Hybrid Remote State Management:** State files are anchored in AWS S3 (Primary) and Azure Blob Storage (Add-on) with versioning to ensure global state durability.
* **Distributed State Locking:** Utilizes AWS DynamoDB as the centralized locking mechanism to prevent concurrent execution conflicts across the multi-cloud environment
* **Granular Multi-Cloud IAM:** Implements least-privilege access using AWS IAM Users, GCP Service Accounts, and Azure RBAC (e.g., Storage Blob Data Owner) to isolate data plane and management plane operations [cite: 2026-02-28].
* **Modular Multi-Cloud Design:** Maintains isolated directory structures for aws/, gcp/, and azure/ to prevent provider bloat and ensure clean state boundaries [cite: 2026-02-28].
* **Cross-Cloud Handshake (BigQuery Omni):** Leverages OIDC (OpenID Connect) to allow GCP to securely assume AWS IAM roles, enabling seamless cross-cloud data analysis without moving data [cite: 2026-02-28].
* **Uniform Component Architecture:** Standardizes every cloud folder with a consistent layout (main.tf, providers.tf, variables.tf, outputs.tf) to support scaling to 500+ resources [cite: 2026-02-28].
* **Cloud-Native FinOps:** Automated budget alarms across AWS (CloudWatch) and GCP (Billing) to maintain strict cost control and prevent cloud sprawl [cite: 2026-02-28].

---

## 🛠️ Tech Stack
* **IaC:** Terraform
* **Primary Cloud (AWS - Depth):** S3 (State & Data), IAM (OIDC & Governance), DynamoDB (State Locking), CloudWatch (FinOps)
* **Add-on Cloud (GCP - Specialized):** BigQuery (Warehousing), BigQuery Connection API (Omni), GCS, Billing Budgets
* **Add-on Cloud (Azure - Specialized):** Resource Groups, Blob Storage (Secondary State/Data), RBAC (Data Plane Security)
* **Data Architecture:** Cross-Cloud Data Lakehouse
* **Security & CI/CD:** GitHub Actions, `.tfvars` Isolation, OIDC Federation
* **Version Control:** Git
---
## 📂 Project Structure

```text
.
├── .github/
│   └── workflows/
│       └── terraform-check.yml   # CI/CD Pipeline
├── aws/                          # AWS Infrastructure
│   ├── main.tf                   # Provider & Backend Config
│   ├── iam.tf                    # Roles & Policies (Inc. BigQuery Omni Trust)
│   ├── variables.tf       
│   └── outputs.tf
│   └── billing.tf                # Billing FinOPS         
├── gcp/                          # GCP Infrastructure
│   ├── main.tf                   # Dataset & Omni Connection
│   ├── gcp-keys.json             # SECRET: GCP Credentials (Git-ignored)
│   └── variables.tf       
├── azure/                        # Azure Infrastructure 
│   ├── main.tf                   # Resource Group, Storage & Container
│   ├── providers.tf              # Backend (Remote State) & Provider config 
│   ├── variables.tf              # Variable declarations 
│   └── terraform.tfvars          # SECRET: Azure Credentials (Git-ignored)
├── .gitignore                    # Filters for .tfstate, .env, secrets and json keys
└── README.md                     # Project documentation
```
---
## 🤖 CI/CD Automation
This repository uses **GitHub Actions** to ensure code quality:
* **Automated Validation:** Every push to `main` triggers a `terraform validate` check for both AWS ,Azure and GCP modules.
* **Environment-Agnostic Checks:** The pipeline uses conditional logic (`fileexists`) to validate GCP provider syntax without requiring sensitive service account keys in the cloud environment.
---

## 🚀 Getting Started
**Prerequisites:**
* **Terraform CLI (v1.5+):** Installed and available in your PATH.
* **AWS CLI:** Configured via `aws configure` with administrative access for state management.
* **GCP Service Account:** Key file (`gcp-keys.json`) located in the `/gcp` directory (**DO NOT COMMIT**).
* **Azure CLI:** Installed and authenticated via `az login`. 
* **Azure Subscription:** An active subscription where you have "Contributor" and "User Access Administrator" roles.
* **GitHub Account:** For source control and CI/CD execution.

💡 Pro Tip: To run Azure Terraform without a browser login, export these variables in your terminal:
```bash
$env:ARM_SUBSCRIPTION_ID="your-id"
$env:ARM_TENANT_ID="your-id"
$env:ARM_CLIENT_ID="your-id"
$env:ARM_CLIENT_SECRET="your-secret"
```

**Deployment** :To deploy the infrastructure, navigate to the provider-specific directory


```bash
# AWS 
cd aws
#GCP
cd gcp
#Azure
cd azure
# for respective cloud services the initialization, plan and apply stays the same
# Initialize the Backend
terraform init
# Validate & Plan
terraform validate
terraform plan
#Apply Changes
terraform apply
```
---

## **🔒 Security Best Practices**
* No Secrets in Git: All sensitive keys are handled via Terraform outputs or environment variables. The .gitignore file explicitly blocks .tfstate and .env files.
* Encryption: The remote state is encrypted at rest in S3.
* Scoped Access: The iceberg-data-engineer user is restricted to specific S3 buckets and cannot perform administrative tasks.

---

## 📈 Roadmap (Long-Term Trajectory)
- [x] AWS Landing Zone (S3 & IAM)
- [x] Remote State & Locking
- [x] Multi-Cloud Extension (GCP BigQuery)
- [x] Cross-Cloud Federation (BigQuery Omni Handshake)
- [x] CI/CD Pipelines via GitHub Actions
- [x] Azure Infrastructure & Remote State
- [ ] Cloudflare DNS Federation (The Bridge between all three)