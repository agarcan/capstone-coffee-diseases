
resource "aws_iam_role" "detection_lambda_role" {
  name = "iam_for_lambda_detection"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_logging_lambda" {
  role = aws_iam_role.detection_lambda_role.id
  policy_arn = aws_iam_policy.policy_logging_lambda.arn
}

resource "aws_iam_role_policy_attachment" "attach_lambda_trigger_policy" {
  role = aws_iam_role.detection_lambda_role.id
  policy_arn = aws_iam_policy.policy_lambda_trigger.arn
}

resource "aws_iam_role_policy_attachment" "attach_thumbnail_policy" {
  role = aws_iam_role.detection_lambda_role.id
  policy_arn = aws_iam_policy.policy_thumbnail_pool_object.arn
}

resource "aws_iam_policy" "policy_logging_lambda" {
  name   = "function-logging-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogGroup",  
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_policy" "policy_lambda_trigger" {
  name   = "policy_lambda_trigger"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject"
        ],
        Effect : "Allow",
        Resource : "${aws_s3_bucket.bucket-detection-trigger.arn}/*"
      }
    ]
  })
}

resource "aws_iam_policy" "policy_thumbnail_pool_object" {
  name   = "policy_thumbnail_pool_object"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "s3:DeleteObject",
          "s3:PutObject",
          "s3:GetObject"
        ],
        Effect : "Allow",
        Resource : "${var.s3_thumbnail_pool_arn}/*"
      }
    ]
  })
}


