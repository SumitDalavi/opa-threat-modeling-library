# Decisions

## ADR-001: OPA/Rego over tfsec for Custom Policy
**Date:** 2026-08-29  
**Status:** Accepted

**Context:**  
We need to map specific STRIDE threat models to our organization's custom compliance requirements.

**Decision:**  
We selected Open Policy Agent (Rego) over simpler scanners like tfsec or checkov.

**Consequences:**  
- ✅ Allows writing highly specific, custom rules (e.g. enforcing specific labeling structures).
- ✅ OPA is tool-agnostic (can evaluate Kubernetes YAML, Terraform JSON, API payloads).
- ⚠️ Rego has a steep learning curve compared to YAML-based policy engines.
