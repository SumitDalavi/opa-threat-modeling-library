package dos

import future.keywords.if
import future.keywords.in

# STRIDE: Denial of Service — resource limit enforcement

# Deny pods without resource limits (opens DoS vector)
deny[msg] if {
    input.kind == "Pod"
    some container in input.spec.containers
    not container.resources.limits
    msg := sprintf("Container '%v' has no resource limits — DoS risk", [container.name])
}

# Deny HPAs with minReplicas = 0 (service can be scaled to zero accidentally)
deny[msg] if {
    input.kind == "HorizontalPodAutoscaler"
    input.spec.minReplicas == 0
    msg := "HPA minReplicas=0 allows service scale-to-zero — availability/DoS risk"
}

# Deny PodDisruptionBudgets that allow too much disruption
deny[msg] if {
    input.kind == "PodDisruptionBudget"
    input.spec.maxUnavailable == "100%"
    msg := "PodDisruptionBudget allows 100% disruption — equivalent to no protection"
}
