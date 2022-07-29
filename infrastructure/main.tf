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
  s3_thumbnail_pool_id =module.thumbnail_pool.s3_thumbnail_pool_id
  s3_thumbnail_pool_arn = module.thumbnail_pool.s3_thumbnail_pool_arn
  region = var.region
  account_id = local.account_id
  detection_image_docker = var.detection_image_docker
  ecr_repository = var.ecr_repository
}

module thumbnail_pool{
    source = "./modules/thumbnail_pool"
}

module "database" {
    source = "./modules/database"
    submissions_db = var.submissions_db
    location_db = var.location_db
    weather_db = var.weather_db
    detection_db = var.detection_db
}

