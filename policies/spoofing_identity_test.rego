package spoofing_test
import data.spoofing

test_deny_wildcard_principal if {
    count(spoofing.deny) > 0 with input as {
        "Statement": [{"Effect": "Allow", "Action": "sts:AssumeRole", "Principal": "*"}]
    }
}

test_allow_service_principal_without_mfa if {
    count(spoofing.deny) == 0 with input as {
        "Statement": [{"Effect": "Allow", "Action": "sts:AssumeRole",
                       "Principal": "lambda.amazonaws.com"}]
    }
}
