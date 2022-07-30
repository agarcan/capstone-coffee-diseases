
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

resource "aws_iam_role_policy_attachment" "attach_logging_lambda_detection" {
  role = aws_iam_role.detection_lambda_role.id
  policy_arn = aws_iam_policy.policy_logging_lambda_detection.arn
}

resource "aws_iam_role_policy_attachment" "attach_lambda_trigger_detection_policy" {
  role = aws_iam_role.detection_lambda_role.id
  policy_arn = aws_iam_policy.policy_lambda_trigger_detection.arn
}

resource "aws_iam_role_policy_attachment" "attach_thumbnail_policy" {
  role = aws_iam_role.detection_lambda_role.id
  policy_arn = aws_iam_policy.policy_thumbnail_pool_object.arn
}

resource "aws_iam_role_policy_attachment" "attach_dynamo_db_detection_policy" {
  role = aws_iam_role.detection_lambda_role.id
  policy_arn = aws_iam_policy.policy_dynamo_db_write_detection.arn
}

resource "aws_iam_policy" "policy_logging_lambda_detection" {
  name   = "function-logging-policy_detection"
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

resource "aws_iam_policy" "policy_lambda_trigger_detection" {
  name   = "policy_lambda_trigger_detection"
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


resource "aws_iam_policy" "policy_dynamo_db_write_detection" {
  name = "policy_dynamo_db_write_detection"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0"
        Action = [
          "dynamoDB:PutItem"
        ]
        Effect   = "Allow"
        Resource = "${var.detection_db_arn}"
      }
    ]
  })
}
