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
  pubsubnet_id = module.bastion_host.pubsubnet_id
  lambda_db_sg_id = module.database.lambda_db_sg_id
  db_name = module.database.db_name
  db_password = module.database.db_password
  db_username = module.database.db_username
  db_endpoint = module.database.db_endpoint

}

module "weather" {
	source = "./modules/weather"
  region = var.region
  account_id = local.account_id
  weather_image_docker = var.weather_image_docker
  ecr_repository = var.ecr_repository
  weather_api_key = var.weather_api_key
  pubsubnet_id = module.bastion_host.pubsubnet_id
  lambda_db_sg_id = module.database.lambda_db_sg_id
  db_name = module.database.db_name
  db_password = module.database.db_password
  db_username = module.database.db_username
  db_endpoint = module.database.db_endpoint
}

module thumbnails{
    source = "./modules/thumbnails"
}

module "database" {
    source = "./modules/database"
    coffeeleaves_vpc_id = module.bastion_host.coffeeleaves_vpc_id
    privsubnet1_id = module.bastion_host.privsubnet1_id
    privsubnet2_id = module.bastion_host.privsubnet2_id
    region = var.region
}

module "bastion_host" {
    source = "./modules/bastion_host"
}

