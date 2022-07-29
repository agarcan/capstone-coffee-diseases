
  locals {
    detection_image_uri = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repository}:${var.detection_image_docker}"
  }

