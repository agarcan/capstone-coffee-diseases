
resource "aws_iam_role" "weather_lambda_role" {
  name = "iam_for_lambda_weather"

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

resource "aws_iam_role_policy_attachment" "attach_logging_lambda_weather" {
  role = aws_iam_role.weather_lambda_role.id
  policy_arn = aws_iam_policy.policy_logging_lambda_weather.arn
}

resource "aws_iam_role_policy_attachment" "attach_lambda_trigger_policy_weather" {
  role = aws_iam_role.weather_lambda_role.id
  policy_arn = aws_iam_policy.policy_lambda_trigger_weather.arn
}


resource "aws_iam_role_policy_attachment" "attach_dynamo_db_policy_weather" {
  role = aws_iam_role.weather_lambda_role.id
  policy_arn = aws_iam_policy.policy_dynamo_db_write_weather.arn
}

resource "aws_iam_role_policy_attachment" "attach_vpc_access_weather_policy" {
  role = aws_iam_role.weather_lambda_role.id
  policy_arn = aws_iam_policy.policy_weather_access_vpc.arn
}

resource "aws_iam_policy" "policy_logging_lambda_weather" {
  name   = "function-logging-policy_weather"
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

resource "aws_iam_policy" "policy_lambda_trigger_weather" {
  name   = "policy_lambda_trigger_weather"
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
        Resource : "${aws_s3_bucket.bucket-weather-trigger.arn}/*"
      }
    ]                              
  })
}


resource "aws_iam_policy" "policy_weather_access_vpc"{
  name = "policy_dynamo_db_write_weather"
  
  policy = jsonencode({
    Version="2012-10-17",
    Statement = [
        {
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface",
                "ec2:AssignPrivateIpAddresses",
                "ec2:UnassignPrivateIpAddresses"
            ],
            Effect="Allow",
            Resource="*"
        }
    ]
})
}