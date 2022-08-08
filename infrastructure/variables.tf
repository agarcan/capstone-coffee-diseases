

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
variable "submissions_db" {
  description = "Table containing user, date of submission and submission id"
  type = string
  default = "submissions_db"
}

variable "location_db" {
  description = "Table containing submission location"
  type = string
  default = "location_db"
}

variable "weather_db" {
  description = "Table containing weather statistics preceding the submission"
  type = string
  default = "weather_db"
}

variable "detection_db" {
  description = "Table containing the detection labels of each submission"
  type = string
  default = "detection_db"
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