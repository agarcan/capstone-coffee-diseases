

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