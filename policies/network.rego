package threat_model.network

default deny_public_s3 = false

deny_public_s3 {
    input.resource_type == "aws_s3_bucket"
    input.acl == "public-read"
}
