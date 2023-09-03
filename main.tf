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

module "cw" {
  source = "./modules/cloudwatch"

  cloudtrail_cloudwatch_group_name = module.cloudtrail.trail_cw_group_name
  sns_topic_subscription_email     = var.sns_topic_subscription_email
}
