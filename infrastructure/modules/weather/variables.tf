

#variable "weather_db_arn" {
#  description = "Arn of the dynamo DB table containing submission weather results"
#  type = string
#}

#variable "location_db_arn" {
#  description = "Arn of the dynamo DB table containing submission locations"
#  type = string
#}

#variable "submissions_db_arn" {
#  description = "Arn of the dynamo DB table containing submission locations"
#  type = string
#}


variable "db_private_subnet" {
    type = string
}

variable "db_security_group" {
    type = string
}

variable "region" {
    type = string
}
variable "ecr_repository" {
    type = string
}
variable "account_id"{
    type = string
}

variable "weather_image_docker" {
    type = string
}

variable "weather_api_key" {
    type = string
}

variable "db_username" {
    type = string
}

variable "db_password" {
    type = string
}

variable "db_name" {
    type = string
}
 
variable "db_endpoint" {
    type = string
}

variable "privsubnet1_id"{
  type = string 
}

variable "privsubnet2_id"{
  type = string 
}

variable "bh_sg_id" {
  type = string
}

variable "db_sg_id" {
  type = string
}