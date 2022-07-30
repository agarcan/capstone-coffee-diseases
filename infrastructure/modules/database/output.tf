output "detection_db_arn" {   
    description = "Arn of the dynamo DB table containing submission detection results"
    value       = aws_dynamodb_table.detection-db.arn 
}

output "submissions_db_arn" {   
    description = "Arn of the dynamo DB table containing submission detection results"
    value       = aws_dynamodb_table.submissions-db.arn 
}

output "weather_db_arn" {   
    description = "Arn of the dynamo DB table containing submission detection results"
    value       = aws_dynamodb_table.weather-db.arn 
}

output "location_db_arn" {   
    description = "Arn of the dynamo DB table containing submission detection results"
    value       = aws_dynamodb_table.location-db.arn 
}