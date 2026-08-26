# STRIDE Threat Model Policy Catalogue

| Category | Policy File | What It Checks |
|----------|-------------|----------------|
| **S**poofing | `spoofing_identity.rego` | IAM wildcard principals, MFA on role assumption |
| **T**ampering | `tampering_rds_encryption.rego` | RDS encryption at rest |
| **R**epudiation | `repudiation_logging.rego` | CloudTrail enabled, S3 access logs, log retention |
| **I**nformation Disclosure | `information_disclosure_s3.rego` | Public S3 buckets, unencrypted buckets |
| **D**enial of Service | `dos_resource_limits.rego` | K8s resource limits, HPA minReplicas, PDB limits |
| **E**levation of Privilege | `elevation_of_privilege_iam.rego` | Wildcard IAM actions, admin policies |

## Usage

```bash
# Evaluate all policies against a Terraform plan
opa eval -d policies/ -I -f pretty < data/tfplan_good.json

# Run tests
opa test policies/ -v

# Check coverage
opa test policies/ --coverage
```
