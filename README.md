# Multi-Cloud Data Engineering Infrastructure (IaC)

This repository serves as a centralized Infrastructure-as-Code (IaC) hub for a scalable, multi-cloud data ecosystem. The goal is to build a production-ready environment that supports advanced data lakehouse architectures (like Apache Iceberg) while adhering to industry-standard DevOps practices.

## 🏗️ Architecture Overview

The infrastructure is designed for **Scalability**, **Security**, and **Collaboration**. By utilizing Terraform, we ensure that the environment is version-controlled and reproducible across different cloud providers.

### Current Cloud Providers:
* **AWS (Amazon Web Services):** Primary storage and identity management.

### Key Infrastructure Pillars:
* **Remote State Management:** State files are stored in S3 with versioning enabled to prevent data loss.
* **State Locking:** Utilizes DynamoDB to prevent concurrent execution and state corruption.
* **Least Privilege IAM:** Dedicated service accounts (IAM Users) with scoped-down policies for data operations.
* **Modular Design:** Code is split into logical components (`main.tf`, `iam.tf`, `outputs.tf`) to support 500+ resource scaling.

---

## 🛠️ Tech Stack
* **IaC:** Terraform
* **Cloud:** AWS (S3, IAM, DynamoDB)
* **Data Architecture:** Apache Iceberg (Landing Zone)
* **Version Control:** Git


## 🚀 Getting Started
**Prerequisites:**
* Terraform CLI installed.
* AWS CLI configured with administrative access.
* A GitHub account for source control.

**Deployment** :To deploy the AWS infrastructure, navigate to the provider-specific directory:

Enter the AWS Directory:
```bash
cd aws
# Initialize the Backend:
terraform init

```
**Validate & Plan**:
```bash
terraform validate
terraform plan
```
**Apply Changes:**
```bash
terraform apply
```
---

## **🔒 Security Best Practices**
* No Secrets in Git: All sensitive keys are handled via Terraform outputs or environment variables. The .gitignore file explicitly blocks .tfstate and .env files.
* Encryption: The remote state is encrypted at rest in S3.
* Scoped Access: The iceberg-data-engineer user is restricted to specific S3 buckets and cannot perform administrative tasks.

---

## 📈 Roadmap (Long-Term Trajectory)
* [x] AWS Landing Zone (S3 & IAM)
* [x] Remote State & Locking
* [ ] Apache Iceberg Table Implementation
* [ ] Multi-Cloud Extension (Azure/GCP)
* [ ] CI/CD Pipelines via GitHub Actions

---

## 📂 Project Structure

```text
.
├── aws/                   # AWS Specific Infrastructure
│   ├── main.tf            # Provider & Core Storage (S3)
│   ├── iam.tf             # Identity & Access (Policies, Users, Keys)
│   ├── variables.tf       # Configurable parameters
│   ├── outputs.tf         # Exported resource IDs
├── .gitignore             # Safety filter to prevent secret leaks
└── README.md              # Project documentation