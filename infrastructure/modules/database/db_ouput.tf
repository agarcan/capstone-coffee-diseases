output "db_id" {
  description = "Id of the database"
  value       = aws_db_instance.coffeeleaves_db.id
}

output "db_arn" {
  description = "Arn of the database"
  value       = aws_db_instance.coffeeleaves_db.arn
}

output "db_name"{
  description = "name of database"
  value       = var.db_name
}

output "username"{
  description = "username of database"
  value       = var.username
}

output "password"{
  description = "password of database"
  value       = var.password
}
