package terraform.analysis

test_deny_s3_public_read {
	res := deny with input as {
		"resource_changes": [
			{
				"type": "aws_s3_bucket",
				"name": "bad_bucket",
				"change": {
					"after": {
						"acl": "public-read"
					}
				}
			}
		]
	}
	res == {"[Information Disclosure] S3 bucket 'bad_bucket' is configured with public-read ACL."}
}

test_allow_s3_private {
	res := deny with input as {
		"resource_changes": [
			{
				"type": "aws_s3_bucket",
				"name": "good_bucket",
				"change": {
					"after": {
						"acl": "private"
					}
				}
			}
		]
	}
	count(res) == 0
}
