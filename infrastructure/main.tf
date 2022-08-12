terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8.0"
    }
  }
  backend "s3" {
    bucket = "terraform-cloud-state-bucket"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "detection" {
	source = "./modules/detection"
  s3_thumbnail_pool_id =module.thumbnails.s3_thumbnail_pool_id
  s3_thumbnail_pool_arn = module.thumbnails.s3_thumbnail_pool_arn
  region = var.region
  account_id = local.account_id
  detection_image_docker = var.detection_image_docker
  ecr_repository = var.ecr_repository
  detection_db_arn = module.database.detection_db_arn
}

module "weather" {
	source = "./modules/weather"
  region = var.region
  account_id = local.account_id
  weather_image_docker = var.weather_image_docker
  ecr_repository = var.ecr_repository
  weather_api_key = var.weather_api_key
  #weather_db_arn = module.database.weather_db_arn
  #submissions_db_arn = module.database.submissions_db_arn
  #location_db_arn = module.database.location_db_arn
}

module thumbnails{
    source = "./modules/thumbnails"
}

module "database" {
    source = "./modules/database"
    submissions_db = var.submissions_db
    location_db = var.location_db
    weather_db = var.weather_db
    detection_db = var.detection_db
}

