package threat_model.iam

default deny_overly_permissive_iam = false

deny_overly_permissive_iam {
    input.resource_type == "aws_iam_policy"
    statement := input.policy.Statement[_]
    statement.Effect == "Allow"
    statement.Action == "*"
    statement.Resource == "*"
}
