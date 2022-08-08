
variable "s3_thumbnail_pool_id" {
    description = "Id of the S3 bucket where resized images are stored"
    type = string
}

variable "s3_thumbnail_pool_arn" {
    description = "Arn of the S3 bucket where resized images are stored"
    type = string
}

variable "detection_db_arn" {
  description = "Arn of the dynamo DB table containing submission detection results"
  type = string
}

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