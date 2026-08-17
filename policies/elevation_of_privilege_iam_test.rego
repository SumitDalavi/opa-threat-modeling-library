package terraform.analysis

test_deny_iam_wildcard {
	res := deny with input as {
		"resource_changes": [
			{
				"type": "aws_iam_policy",
				"name": "bad_policy",
				"change": {
					"after": {
						"policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":\"*\",\"Effect\":\"Allow\",\"Resource\":\"*\"}]}"
					}
				}
			}
		]
	}
	res == {"[Elevation of Privilege] IAM policy 'bad_policy' allows full administrative access (Action: *, Resource: *)."}
}

test_allow_iam_limited {
	res := deny with input as {
		"resource_changes": [
			{
				"type": "aws_iam_policy",
				"name": "good_policy",
				"change": {
					"after": {
						"policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"s3:GetObject\"],\"Effect\":\"Allow\",\"Resource\":[\"arn:aws:s3:::my-private-data/*\"]}]}"
					}
				}
			}
		]
	}
	count(res) == 0
}
