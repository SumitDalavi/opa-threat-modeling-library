package spoofing

import future.keywords.if
import future.keywords.in

# STRIDE: Spoofing — IAM impersonation and identity falsification checks

# Deny IAM policies that allow assume-role from any principal (*)
deny[msg] if {
    some stmt in input.Statement
    stmt.Effect == "Allow"
    stmt.Action == "sts:AssumeRole"
    stmt.Principal == "*"
    msg := "IAM policy allows sts:AssumeRole from wildcard principal (*) — identity spoofing risk"
}

# Deny if MFA is not required for human role assumption
deny[msg] if {
    some stmt in input.Statement
    stmt.Effect == "Allow"
    stmt.Action == "sts:AssumeRole"
    not _requires_mfa(stmt)
    not _is_service_principal(stmt)
    msg := "Role assumption for human principals must require MFA condition"
}

_requires_mfa(stmt) if {
    stmt.Condition["Bool"]["aws:MultiFactorAuthPresent"] == "true"
}

_is_service_principal(stmt) if {
    p := stmt.Principal
    endswith(p, ".amazonaws.com")
}
