resource "aws_lambda_function" "weather_lambda" {
  function_name = "fetch-weather-lambda"
  role          = aws_iam_role.weather_lambda_role.arn
  package_type  = "Image"
  timeout          = 120 #sec
  memory_size = 1000

  ephemeral_storage {
    size = 1000 # Min 512 MB and the Max 10240 MB
  }
  
  # set 
  vpc_config {
    subnet_ids         = [var.pubsubnet_id]
    security_group_ids = [var.lambda_db_sg_id]
  }

  environment {
    variables = {
      API_KEY = var.weather_api_key
      DB_USERNAME = var.db_username
      DB_PASSWD   = var.db_password
      DB_NAME     = var.db_name
      DB_ENDPOINT = var.db_endpoint
    }
  }
  # URI of the image in the ECR repository
  image_uri     = local.weather_image_uri
}

resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.weather_lambda.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}


resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.weather_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket-weather-trigger.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket-weather-trigger.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.weather_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".json"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}