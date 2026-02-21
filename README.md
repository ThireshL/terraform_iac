![Terraform Validation](https://github.com/ThireshL/terraform_iac/actions/workflows/terraform-check.yml/badge.svg)

# Multi-Cloud Data Engineering Infrastructure (IaC)

This repository serves as a centralized Infrastructure-as-Code (IaC) hub for a scalable, multi-cloud data ecosystem. The goal is to build a production-ready environment that supports advanced data lakehouse architectures (like Apache Iceberg/Apache Superset) while adhering to industry-standard DevOps practices.

## 🏗️ Architecture Overview

The infrastructure is designed for **Scalability**, **Security**, and **Collaboration**. By utilizing Terraform, we ensure that the environment is version-controlled and reproducible across different cloud providers.

### Current Cloud Providers:
* **AWS (Amazon Web Services):** Primary storage and identity management.
* **GCP (Google Cloud Platform):** Data warehousing (BigQuery) and cross-cloud query execution.

### Key Infrastructure Pillars:
* **Remote State Management:** State files are stored in S3 with versioning enabled to prevent data loss.
* **State Locking:** Utilizes DynamoDB to prevent concurrent execution and state corruption.
* **Least Privilege IAM:** Dedicated service accounts (IAM Users) with scoped-down policies for data operations.
* **Modular Design:** Code is split into logical components (`main.tf`, `iam.tf`, `outputs.tf`) to support 500+ resource scaling.
* **Cross-Cloud Handshake (BigQuery Omni):** Uses OIDC (OpenID Connect) to allow GCP to securely "assume" an AWS IAM role to read S3 data directly.
* **Modular Multi-Cloud Design:**: Isolated directories for aws/ and gcp/ to prevent provider conflicts and maintain clean state boundaries.
* **FinOps & Cost Control:** Automated $1.00 Budget Alarms in both AWS (CloudWatch) and GCP (Billing Budgets) to prevent unexpected cloud sprawl.
* **Automated API Management:** Uses google_project_service to manage GCP service activations, ensuring a "Zero-Touch" setup experience.

---

## 🛠️ Tech Stack
* **IaC:** Terraform
* **Cloud(AWS):** S3, IAM, DynamoDB
* **Cloud(GCP):** BigQuery, BigQuery Connection API, GCS
* **Data Architecture:** Cross-Cloud Data Lakehouse
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
├── .gitignore                    # Filters for .tfstate, .env, and json keys
└── README.md                     # Project documentation
```
---
## 🤖 CI/CD Automation
This repository uses **GitHub Actions** to ensure code quality:
* **Automated Validation:** Every push to `main` triggers a `terraform validate` check for both AWS and GCP modules.
* **Environment-Agnostic Checks:** The pipeline uses conditional logic (`fileexists`) to validate GCP provider syntax without requiring sensitive service account keys in the cloud environment.
---

## 🚀 Getting Started
**Prerequisites:**
* Terraform CLI installed.
* AWS CLI configured with administrative access.
* GCP Service Account key (gcp-keys.json) located in the /gcp directory (**DO NOT COMMIT THIS FILE**).
* A GitHub account for source control.

**Deployment** :To deploy the infrastructure, navigate to the provider-specific directory


```bash
# AWS 
cd aws
#GCP
cd gcp
# for both cloud the initialization, plan and apply stays the same
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
- [ ] Apache Iceberg Table Implementation & Partitioning
- [ ] Data Ingestion Pipeline (AWS Glue or Airflow)