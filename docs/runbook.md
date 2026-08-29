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
