# OPA Threat Modeling Library

> **Maturity:** Lab / Reference Implementation
> _A portfolio project demonstrating how to scale threat modeling by translating STRIDE concepts into automated Infrastructure-as-Code checks using Open Policy Agent (OPA) and Rego._

## The Problem
Manual threat modeling (using tools like Threat Dragon or physical whiteboards) does not scale to modern CI/CD pipelines. Security teams cannot review every single Terraform pull request to determine if it introduces an "Elevation of Privilege" or "Information Disclosure" threat.

## The Solution
This library bridges the gap between theoretical threat modeling and concrete DevSecOps pipelines. By codifying STRIDE threats into Rego policies, we can automatically evaluate Terraform JSON plans *before* infrastructure is provisioned, blocking deployments that violate our threat model.

```text
+-------------------+       +-----------------------+       +-------------------+
|   Terraform Plan  | ----> |   OPA / Rego Engine   | ----> |   CI/CD Pipeline  |
|   (JSON Output)   |       |   (STRIDE Policies)   |       |   (Block/Allow)   |
+-------------------+       +-----------------------+       +-------------------+
```

## Why This Over the Obvious Alternative
While tools like Checkov or tfsec are great out-of-the-box, enterprise platform teams often need to write custom, highly specific rules (e.g., "S3 buckets with the `data-classification: public` label are allowed to be public, all others must be private"). OPA is the industry standard for custom policy-as-code, and writing Rego demonstrates advanced platform engineering capability.

## Tech Stack
- **Policy Engine**: Open Policy Agent (OPA)
- **Language**: Rego
- **Data Source**: Terraform Plan JSON

## Decision Log

| Threat Category (STRIDE) | Rego Implementation | Rationale |
| :--- | :--- | :--- |
| **Information Disclosure** | `information_disclosure_s3.rego` | Detects S3 buckets configured with `public-read` or `public-read-write` ACLs. |
| **Elevation of Privilege** | `elevation_of_privilege_iam.rego` | Flags any IAM policy statement combining `Action: "*"` and `Resource: "*"`. |
| **Tampering** | `tampering_rds_encryption.rego` | Ensures RDS instances have `storage_encrypted` set to true, preventing unauthorized data tampering via underlying storage access. |

## Project Structure

```text
opa-threat-modeling-library/
├── data/
│   ├── tfplan_bad.json                     # Mock TF plan violating policies
│   └── tfplan_good.json                    # Mock TF plan compliant with policies
├── policies/
│   ├── elevation_of_privilege_iam.rego     # OPA policy for IAM
│   ├── elevation_of_privilege_iam_test.rego
│   ├── information_disclosure_s3.rego      # OPA policy for S3
│   ├── information_disclosure_s3_test.rego
│   ├── tampering_rds_encryption.rego       # OPA policy for RDS
│   └── tampering_rds_encryption_test.rego
├── scripts/
│   └── demo.sh                             # Docker-based script to test policies
└── README.md                               # This file
```

## Setup & Usage

### Prerequisites
You need either the `opa` CLI binary installed locally, or Docker (to use the official `openpolicyagent/opa` image).

### 1. Run the Demo Script
The included script uses Docker to run the OPA tests and evaluations without requiring a local installation:
```bash
./scripts/demo.sh
```

### 2. Manual Evaluation (if OPA is installed)
**Run Unit Tests:**
```bash
opa test policies/ -v
```

**Evaluate Bad Terraform Plan:**
```bash
opa eval -d policies/ -i data/tfplan_bad.json "data.terraform.analysis.deny"
```
*Expected Output: Deny messages for Information Disclosure (S3), Tampering (RDS), and Elevation of Privilege (IAM).*

## Verification

| Check | Expected Result |
| :--- | :--- |
| Unit Tests | `opa test` passes all tests. |
| Bad Plan | Returns 3 specific violation strings corresponding to the STRIDE policies. |
| Good Plan | Returns an empty array `[]` (no violations). |

## 📚 Documentation

- [Architecture](docs/architecture.md) — How OPA integrates with Terraform
- [STRIDE Catalogue](docs/STRIDE-CATALOGUE.md) — Mapping OPA fixtures to STRIDE threat models
- [Runbook](docs/runbook.md) — How to run evaluations locally
- [Decisions](docs/decisions.md) — ADRs for Policy-as-Code
- [Changelog](docs/changelog.md) — Change history

## Mock Boundaries (Honest Scope)

| What | Status | Details |
|---|---|---|
| OPA Engine | **Real** | Executing actual Rego policies against JSON inputs using the real OPA binary/container. |
| Terraform Plans | **Mocked** | Using static JSON files (`data/tfplan_bad.json`) rather than dynamically generating them via `terraform plan -out`. |
| CI Pipeline | **Real** | A GitHub Actions workflow is provided to demonstrate automated `opa test --coverage`. |

## Author

**Sumit Dalavi — Senior DevSecOps / Platform Engineer**
- [GitHub](https://github.com/SumitDalavi)
- [LinkedIn](https://in.linkedin.com/in/sumit-dalavi-762838129)
