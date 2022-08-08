#output "db_id" {
##  description = "Id of the database"
#  value       = aws_db_instance.coffeeleaves_db.id
#}

#output "db_arn" {
#  description = "Arn of the database"
#  value       = aws_db_instance.coffeeleaves_db.arn
#}

output "db_name"{
  description = "name of database"
  value       = var.db_name
}

output "db_username"{
  description = "username of database"
  value       = var.username
}

output "db_password"{
  description = "password of database"
  value       = var.password
}

output "db_sg_id"{
  value = aws_security_group.coffee-db-bastion-sg.id
}

output "db_endpoint"{
  value = aws_db_instance.coffeeleaves_db.id
}
