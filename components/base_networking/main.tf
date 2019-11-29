terraform {
  backend "s3" {
    bucket = "mtw-dataeng-twdu2b-tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "~> 2.0"
}

module "training_vpc" {
  source = "../../modules/base_networking"

  deployment_identifier = "data-eng-${var.cohort}${var.env}" //data-eng-twdu2b-dev
  vpc_cidr              = "10.0.0.0/16"
  private_dns_zone_name = "${var.cohort}${var.env}.training"
  availability_zones = [
    "${var.aws_region}a",
    "${var.aws_region}b",
    "${var.aws_region}c"
  ]
}