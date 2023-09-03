terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

module "sgs" {
  source = "./modules/sgs"
}

module "cloudtrail" {
  source = "./modules/cloudtrail"
}

module "cloudwatch_logs_metric_filter" {
  source                           = "./modules/cw-metrics"
  cloudtrail_cloudwatch_group_name = module.cloudtrail.trail_cw_group_name
}
