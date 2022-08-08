resource "aws_lambda_function" "detection_lambda" {
  function_name = "model-serving-lambda"
  
  role          = aws_iam_role.detection_lambda_role.arn
  package_type  = "Image"
  timeout          = 120 #sec
  memory_size = 3000

  ephemeral_storage {
    size = 3000 # Min 512 MB and the Max 10240 MB
  }
  
  # URI of the image in the ECR repository
  image_uri     = local.detection_image_uri
  vpc_config {
    subnet_ids         = [var.bh_sg_id, var.db_sg_id]
    security_group_ids = [var.privsubnet1_id, var.privsubnet2_id]
  }
  environment {
    variables = {
      DB_USERNAME = var.db_username
      DB_PASSWD   = var.db_password
      DB_NAME     = var.db_name
      DB_ENDPOINT = var.db_endpoint
    }
  }
}

resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.detection_lambda.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}


resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.detection_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket-detection-trigger.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket-detection-trigger.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.detection_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

