# Autonomous Zero-Trust Document Ingestion & FinOps Platform Baseline

## Overview
Production-grade Terraform baseline for deploying an Autonomous Zero-Trust Document Ingestion and FinOps Platform on AWS. This infrastructure blueprint enforces strict security principles, automated document processing workflows, fine-grained access control, continuous compliance monitoring, and real-time cloud cost optimization.

## Architecture & Core Components
- **Zero-Trust Network & Identity Access**: VPC Private Subnets, AWS KMS customer-managed keys (CMK) with envelope encryption, IAM Roles with Least Privilege policies, AWS WAF, and AWS PrivateLink.
- **Document Ingestion Pipeline**: Amazon S3 (Server-Side Encryption KMS, Versioning, Object Lock), AWS Lambda / ECS Fargate workers for automated document ingestion, parsing, and metadata indexing, Amazon EventBridge for event-driven orchestration.
- **FinOps & Cost Optimization Engine**: AWS Budgets, AWS Cost Explorer integration, automated resource tagging enforcement, AWS Compute Optimizer recommendations, and Lambda-based auto-scaling/downscaling schedulers.
- **Security & Compliance Monitoring**: AWS CloudTrail, Amazon GuardDuty, AWS Security Hub, Amazon CloudWatch Alarms, and Config Rules for real-time anomaly detection and compliance tracking.

## Repository Structure
```
.
├── main.tf                 # Primary module orchestrating core infrastructure
├── variables.tf            # Input variables for environment configuration
├── outputs.tf              # Exported resource attributes and endpoints
├── terraform.tfvars.example # Example variable values
├── modules/
│   ├── zero_trust_iam/     # Fine-grained IAM roles and KMS key policies
│   ├── ingestion_pipeline/ # S3, EventBridge, Lambda / Fargate ingestion services
│   ├── finops_engine/      # Budgets, tagging rules, cost anomaly detection
│   └── monitoring/         # CloudWatch, CloudTrail, GuardDuty integration
└── README.md               # Platform documentation
```

## Deployment Prerequisites
- Terraform >= 1.5.0
- AWS CLI v2 configured with appropriate administrator permissions
- S3 Backend configured for remote state storage with DynamoDB state locking

## Quick Start
1. **Clone the repository:**
   ```bash
   git clone https://github.com/ishanng15-prog/aws-terraform-production-baseline.git
   cd aws-terraform-production-baseline
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Configure Variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your environment settings
   ```

4. **Plan & Apply:**
   ```bash
   terraform plan -out=tfplan
   terraform apply tfplan
   ```

## Security & Compliance
- **Zero-Trust Principles**: Enforces explicit verification, least privilege access, and assumed breach posture.
- **Data Encryption**: All data encrypted in transit (TLS 1.3) and at rest (AWS KMS CMK).
- **Audit Logging**: Mandatory immutable CloudTrail and S3 access logging enabled.

## License
MIT License.
