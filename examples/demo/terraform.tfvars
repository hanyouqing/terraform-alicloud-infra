# @reference:
#   https://www.terraform.io/docs/configuration/variables.html
#
# @load order: (later overide earlier)
#   environment variables
#   terraform.tfvars
#   terraform.tfvars.json
#   *.auto.tfvars / *.auto.tfvars.json
#   -var / -var-file
#
debug       = true

# common variables
region       = "cn-beijing"
region_abbr  = "bj"
tags = {
    environment = "testing"     # develop|testing|staging|production
    department  = "infrastructure"
    createby    = "ihanyouqing@gmail.com"
    project     = "icmdb"
    service     = "iwebhook"
    owner       = "icmdb"
    provisioner = "terraform"
}

# datasource variables
datasource_dir          = "./tf-jsondata"

# vpc variables
vpc_name                = "icmdb"
vpc_description         = "icmdb"
vpc_availability_zone   = "cn-beijing-e"
vpc_inner_access_policy = "Drop"            # Accept|Drop, allow from all in the same security group
vpc_whitelist_ips       = "106.38.171.130"
vpc_sg_policy_ssh       = "accept"          # accept|drop
vpc_sg_policy_http      = "accept"
vpc_sg_policy_https     = "drop"

# dns variables
dns_group               = "icmdb"
dns_domain_name         = "icmdb.top"
dns_inc_value           = "192.168.1.1"
dns_www_value           = "192.168.1.2"
dns_develop_value       = "192.168.1.3"
dns_testing_value       = "192.168.1.4"
dns_staging_value       = "192.168.1.5"
dns_aliyundm_mail_value = "40e907d7419a4cb884e4"