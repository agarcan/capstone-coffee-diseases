data "aws_caller_identity" "current"{}

locals {
    account_id = data.aws_caller_identity.current.account_id
    aws_ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
}
