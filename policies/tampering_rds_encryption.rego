package terraform.analysis

import data.terraform.plan as plan

get_aws_db_instances[r] {
	r := input.resource_changes[_]
	r.type == "aws_db_instance"
}

# STRIDE: Tampering (and Information Disclosure)
# RDS instances must have storage encryption enabled
deny[msg] {
	db := get_aws_db_instances[_]
	db.change.after.storage_encrypted == false
	msg := sprintf("[Tampering] RDS database '%v' does not have storage encryption enabled.", [db.name])
}

deny[msg] {
	db := get_aws_db_instances[_]
	not has_key(db.change.after, "storage_encrypted")
	msg := sprintf("[Tampering] RDS database '%v' does not have storage encryption enabled (missing attribute).", [db.name])
}

has_key(obj, k) {
	_ = obj[k]
}
