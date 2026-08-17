package terraform.analysis

test_deny_rds_unencrypted {
	res := deny with input as {
		"resource_changes": [
			{
				"type": "aws_db_instance",
				"name": "bad_db",
				"change": {
					"after": {
						"storage_encrypted": false
					}
				}
			}
		]
	}
	res == {"[Tampering] RDS database 'bad_db' does not have storage encryption enabled."}
}

test_deny_rds_missing_encryption {
	res := deny with input as {
		"resource_changes": [
			{
				"type": "aws_db_instance",
				"name": "bad_db",
				"change": {
					"after": {
						"allocated_storage": 20
					}
				}
			}
		]
	}
	res == {"[Tampering] RDS database 'bad_db' does not have storage encryption enabled (missing attribute)."}
}

test_allow_rds_encrypted {
	res := deny with input as {
		"resource_changes": [
			{
				"type": "aws_db_instance",
				"name": "good_db",
				"change": {
					"after": {
						"storage_encrypted": true
					}
				}
			}
		]
	}
	count(res) == 0
}
