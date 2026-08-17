package terraform.analysis

import data.terraform.plan as plan

get_aws_iam_policies[r] {
	r := input.resource_changes[_]
	r.type == "aws_iam_policy"
}

# STRIDE: Elevation of Privilege
# IAM policies must not have Action: "*" and Resource: "*"
deny[msg] {
	policy_res := get_aws_iam_policies[_]
	
	# The policy is usually stored as a JSON string in the plan
	policy_doc := json.unmarshal(policy_res.change.after.policy)
	statement := policy_doc.Statement[_]
	
	statement.Effect == "Allow"
	statement.Action == "*"
	statement.Resource == "*"
	
	msg := sprintf("[Elevation of Privilege] IAM policy '%v' allows full administrative access (Action: *, Resource: *).", [policy_res.name])
}

# Also check if Action is an array containing "*"
deny[msg] {
	policy_res := get_aws_iam_policies[_]
	
	policy_doc := json.unmarshal(policy_res.change.after.policy)
	statement := policy_doc.Statement[_]
	
	statement.Effect == "Allow"
	statement.Action[_] == "*"
	statement.Resource == "*"
	
	msg := sprintf("[Elevation of Privilege] IAM policy '%v' allows full administrative access (Action: [*], Resource: *).", [policy_res.name])
}
