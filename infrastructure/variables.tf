

variable "region" {
  description = "Default region"
  type = string
  default = "eu-central-1"
}

variable "ecr_repository" {
  description = "Name of the ecr repository"
  type = string
  default = "coffeeleaves"
}

variable "detection_image_docker" {
  description = "Name of the docker image containing the inference lambda functions"
  type = string
  default = "lambda_detection_tf_v1" #
}

variable "weather_image_docker" {
  description = "Name of the docker image containing the weather and data processing lambda functions"
  type = string
  default = "lambda_weather_v1"
}

variable "weather_api_key" {
  type = string
}