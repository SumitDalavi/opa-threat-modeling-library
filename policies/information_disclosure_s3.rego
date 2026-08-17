package terraform.analysis

import data.terraform.plan as plan

# Helper: Get all resources of a specific type
get_resources[r] {
	r := input.resource_changes[_]
}

get_aws_s3_buckets[r] {
	r := get_resources[_]
	r.type == "aws_s3_bucket"
}

# STRIDE: Information Disclosure
# S3 Buckets must not have public ACLs
deny[msg] {
	bucket := get_aws_s3_buckets[_]
	bucket.change.after.acl == "public-read"
	msg := sprintf("[Information Disclosure] S3 bucket '%v' is configured with public-read ACL.", [bucket.name])
}

deny[msg] {
	bucket := get_aws_s3_buckets[_]
	bucket.change.after.acl == "public-read-write"
	msg := sprintf("[Information Disclosure] S3 bucket '%v' is configured with public-read-write ACL.", [bucket.name])
}
