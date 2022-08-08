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
  privsubnet1_id = module.bastion_host.privsubnet1_id
  privsubnet2_id = module.bastion_host.privsubnet2_id
  bh_sg_id = module.bastion_host.bh_sg_id
  db_sg_id = module.database.db_sg_id
  db_name = module.database.db_name
  db_password = module.database.db_password
  db_username = module.database.db_username
}

module "weather" {
	source = "./modules/weather"
  region = var.region
  account_id = local.account_id
  weather_image_docker = var.weather_image_docker
  ecr_repository = var.ecr_repository
  weather_api_key = var.weather_api_key
  privsubnet1_id = module.bastion_host.privsubnet1_id
  privsubnet2_id = module.bastion_host.privsubnet2_id
  bh_sg_id = module.bastion_host.bh_sg_id
  db_sg_id = module.database.db_sg_id
  db_name = module.database.db_name
  db_password = module.database.db_password
  db_username = module.database.db_username
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

module "bastion_host" {
    source = "./modules/bastion_host"
}


variable "bh_sg_id" {
  type = string
}

variable "db_sg_id" {
  type = string
}