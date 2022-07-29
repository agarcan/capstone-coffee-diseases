resource "aws_dynamodb_table" "submissions-db" {
  name           = "${var.submissions_db}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "username"
  range_key      = "date"

  attribute {
    name = "username"
    type = "S"
  }

 attribute {
    name = "date"
    type = "S"
  }

}

resource "aws_dynamodb_table" "location-db" {
  name           = "${var.location_db}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "submission_id"

  attribute {
    name = "submission_id"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = "submission-locations-db"
    Environment = "test"
  }
}

resource "aws_dynamodb_table" "weather-db" {
  name           = "${var.weather_db}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "submission_id"

  attribute {
    name = "submission_id"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = "weather-db"
    Environment = "test"
  }
}


resource "aws_dynamodb_table" "detection-db" {
  name           = "${var.detection_db}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "submission_id"
  range_key      = "label"

  attribute {
    name = "submission_id"
    type = "S"
  }

 attribute {
    name = "label"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = "detection-db"
    Environment = "test"
  }
}