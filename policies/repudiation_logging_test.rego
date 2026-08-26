package repudiation_test
import data.repudiation

test_deny_cloudtrail_disabled if {
    count(repudiation.deny) > 0 with input as {
        "resource_type": "aws_cloudtrail",
        "config": {"is_logging": false}
    }
}

test_allow_cloudtrail_enabled if {
    count(repudiation.deny) == 0 with input as {
        "resource_type": "aws_cloudtrail",
        "config": {"is_logging": true}
    }
}

test_deny_short_log_retention if {
    count(repudiation.deny) > 0 with input as {
        "resource_type": "aws_cloudwatch_log_group",
        "config": {"name": "app-logs", "retention_in_days": 7}
    }
}
