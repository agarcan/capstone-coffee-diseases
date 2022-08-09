
variable "s3_thumbnail_pool_id" {
    description = "Id of the S3 bucket where resized images are stored"
    type = string
}

variable "s3_thumbnail_pool_arn" {
    description = "Arn of the S3 bucket where resized images are stored"
    type = string
}

#variable "detection_db_arn" {
#  description = "Arn of the dynamo DB table containing submission detection results"
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

variable "detection_image_docker" {
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

variable "pubsubnet_id"{
  type = string 
}

variable "lambda_db_sg_id" {
  type = string
}
