package repudiation

import future.keywords.if
import future.keywords.in

# STRIDE: Repudiation — ensure all critical actions are logged and tamper-evident

# Deny CloudTrail being disabled
deny[msg] if {
    input.resource_type == "aws_cloudtrail"
    input.config.is_logging == false
    msg := "CloudTrail logging must not be disabled — repudiation risk"
}

# Deny if S3 server access logging is disabled
deny[msg] if {
    input.resource_type == "aws_s3_bucket"
    not input.config.logging
    input.config.acl != "private"
    msg := sprintf("S3 bucket '%v' has no access logging — cannot audit access for non-private buckets", [input.config.bucket])
}

# Deny if log retention < 90 days
deny[msg] if {
    input.resource_type == "aws_cloudwatch_log_group"
    input.config.retention_in_days < 90
    msg := sprintf("CloudWatch log group '%v' retention (%d days) is below 90-day minimum", [input.config.name, input.config.retention_in_days])
}
