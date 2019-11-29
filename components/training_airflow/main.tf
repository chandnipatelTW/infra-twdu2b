terraform {
  backend "s3" {}
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "~> 2.0"
}

data "terraform_remote_state" "base_networking" {
  backend = "s3"
  config {
    key    = "env:/dev/base_networking.tfstate"
    bucket = "tw-dataeng-${var.cohort}-tfstate"
    region = "${var.aws_region}"
  }
}

data "terraform_remote_state" "bastion" {
  backend = "s3"
  config {
    key    = "env:/dev/bastion.tfstate"
    bucket = "tw-dataeng-${var.cohort}-tfstate"
    region = "${var.aws_region}"
  }
}

data "terraform_remote_state" "training_emr_cluster" {
  backend = "s3"
  config {
    key    = "env:/dev/training_emr_cluster.tfstate"
    bucket = "tw-dataeng-${var.cohort}-tfstate"
    region = "${var.aws_region}"
  }
}


module "training_airflow" {
  source = "../../modules/training_airflow"

  deployment_identifier           = "data-eng-${var.cohort}${var.env}"
  instance_type                   = "t2.medium"
  vpc_id                          = "${data.terraform_remote_state.base_networking.vpc_id}"
  subnet_ids                      = "${data.terraform_remote_state.base_networking.private_subnet_ids}"
  dns_zone_id                     = "${data.terraform_remote_state.base_networking.dns_zone_id}"
  ec2_key_pair                    = "tw-dataeng-${var.cohort}${var.env}"
  bastion_security_group_id       = "${data.terraform_remote_state.bastion.bastion_security_group_id}"
  initial_rds_snapshot            = "${var.cohort}${var.env}-airflow"
  rds_snapshot_password_parameter = "${var.cohort}${var.env}-airflow-password"
  rds_instance_class              = "db.t2.small"
  emr_cluster_name                = "${data.terraform_remote_state.training_emr_cluster.emr_cluster_name}"
}
