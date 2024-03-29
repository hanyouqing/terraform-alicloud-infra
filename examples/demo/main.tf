# @reference:
#   https://www.terraform.io/docs/backends/config.html      
#   https://www.terraform.io/docs/backends/types/remote.html
#   https://www.terraform.io/docs/backends/types/oss.html
#   https://www.terraform.io/docs/providers/alicloud/r/vpc.html

terraform {
    required_version = ">= 0.12.18"
    backend "oss" {
        bucket  = "terraform-alicloud-infra"
        prefix  = "cn-beijing/testing/icmdb"  # region/environment/project, region=workspace
        key     = "terraform.tfstate"
        region  = "cn-beijing"
        # tablestore_endpoint = "https://terraform-remote.${var.region}.ots.aliyuncs.com"
        # tablestore_table    = "statelock"
    }
}
# https://www.terraform.io/docs/commands/cli-config.html
# credentials "app.terraform.io" {
#     token = "${var.tf_credentials}"
# }
provider "alicloud" {
    version = ">= 1.64"
}
module "infra" {
    # source                  = "hanyouqing/infra/alicloud"
    source                  = "../../../terraform-alicloud-infra"

    # common variables
    region                  = var.region
    region_abbr             = var.region_abbr
    tags                    = var.tags

    # datasource variables
    datasource_dir          = var.datasource_dir

    # vpc variables
    vpc_name                = var.vpc_name
    vpc_description         = var.vpc_description
    vpc_availability_zone   = var.vpc_availability_zone
    vpc_inner_access_policy = var.vpc_inner_access_policy
    vpc_whitelist_ips       = var.vpc_whitelist_ips
    vpc_sg_policy_ssh       = var.vpc_sg_policy_ssh
    vpc_sg_policy_http      = var.vpc_sg_policy_http
    vpc_sg_policy_https     = var.vpc_sg_policy_https

    # dns variables
    dns_group               = var.dns_group
    dns_domain_name         = var.dns_domain_name
    dns_inc_value           = var.dns_inc_value
    dns_www_value           = var.dns_www_value
    dns_develop_value       = var.dns_develop_value
    dns_testing_value       = var.dns_testing_value
    dns_staging_value       = var.dns_staging_value
    dns_aliyundm_mail_value = var.dns_aliyundm_mail_value
}
# module "ecs" {
#     # source                  = "hanyouqing/vpc/alicloud"
#     source                  = "./modules/vpc"
# }
# module "slb" {
#     # source                  = "hanyouqing/slb/alicloud"
#     source                  = "./modules/slb"
# }