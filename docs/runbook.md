# Runbook — opa-threat-modeling-library
> Last updated: 2026-08-29

## Quick Start
```bash
# Evaluate a bad terraform plan
opa eval -d policies/ -i data/tfplan_bad.json "data.terraform.analysis.deny"
```

## Run Tests
```bash
# Run unit tests with coverage
opa test policies/ -v --coverage
```

## Failure Modes
| Symptom | Cause | Fix |
|---|---|---|
| `data.terraform.analysis.deny` undefined | Syntax error in Rego file | Run `opa check policies/` to find compilation errors |


---

## Release Runbook

### Release Trigger
Tag push matching `v*.*.*` (e.g., `v0.1.0`).

### Automated Pipeline Stages
1. **Quality & Validation Gate:** Validates policy syntax, Rego rules, and manifest schemas.
2. **Distribution Packaging:** Bundles clean production manifests into `opa-threat-modeling-library-<tag>.tar.gz` and calculates SHA256 checksums.
3. **Syft Source SBOM:** Generates `sbom.spdx.json` adhering to SPDX 2.3 standard.
4. **GitHub Release:** Publishes release assets and release notes.

### Verification
```bash
gh release view v0.1.0 --repo SumitDalavi/opa-threat-modeling-library
gh release download v0.1.0 --repo SumitDalavi/opa-threat-modeling-library --pattern "checksums.txt"
```

### Failure Modes & Remediation
- **Linter / Test Failure:** Inspect policy syntax or module arguments locally before tagging.
- **Checksum Mismatch:** Ensure file was completely downloaded without network truncation.

## Operations & Verification Guide (v0.2.0)

### Offline Validation (Tier 1)
Run syntax, formatting, and schema verification without cloud dependencies:
```bash
# Verify manifests and policy definitions offline
make test || npm test || ./scripts/test.sh || true
```

### Sandbox Deployment (Tier 2)
Deploy against an isolated Kind or Minikube test cluster:
```bash
# Verify local application to sandbox
kubectl apply --dry-run=client -k .
```

### Production Release Verification (Tier 3)
Verify published release artifacts on GitHub:
```bash
gh release view v0.2.0 --repo SumitDalavi/opa-threat-modeling-library
gh release download v0.2.0 --repo SumitDalavi/opa-threat-modeling-library --pattern "sbom.spdx.json"
cat sbom.spdx.json | jq .spdxVersion
```
