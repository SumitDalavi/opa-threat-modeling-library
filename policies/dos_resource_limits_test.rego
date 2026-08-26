package dos_test
import data.dos

test_deny_pod_no_limits if {
    count(dos.deny) > 0 with input as {
        "kind": "Pod",
        "spec": {"containers": [{"name": "app", "resources": {}}]}
    }
}

test_allow_pod_with_limits if {
    count(dos.deny) == 0 with input as {
        "kind": "Pod",
        "spec": {"containers": [{"name": "app", "resources": {
            "limits": {"cpu": "500m", "memory": "256Mi"}
        }}]}
    }
}

test_deny_hpa_zero_replicas if {
    count(dos.deny) > 0 with input as {
        "kind": "HorizontalPodAutoscaler",
        "spec": {"minReplicas": 0, "maxReplicas": 10}
    }
}
