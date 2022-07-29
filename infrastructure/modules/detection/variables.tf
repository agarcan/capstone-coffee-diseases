
variable "s3_thumbnail_pool_id" {
    description = "Id of the S3 bucket where resized images are stored"
    type = string
}

variable "s3_thumbnail_pool_arn" {
    description = "Arn of the S3 bucket where resized images are stored"
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