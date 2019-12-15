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
variable "debug"        { default = "" }

variable "region"       { default = "" } # takes region id as workspace name
variable "region_abbr"  { default = "" }

variable "tags" {
    default = {
        environment = ""    # develop|testing|staging|production
        department  = ""
        project     = ""
        service     = ""
        createby    = ""
        owner       = ""
        provisioner = ""
    }
}

variable "demo" {
    default = {
        region            = "cn-beijing"
        availability_zone = "c"
        charge_type       = "PostPaid"      # PrePaid|PostPaid
        network_type      = "Vpc"           # Classic|Vpc

        cpu_core_count    = 2
        memory_size       = 4
        counts            = 1

        img_ubuntu        = "^ubuntu_18"
        img_centos        = "^centos_7"
    }
}

# datasource variables
variable "datasource_dir"           { default = "" }  # should be create maunually

# vpc variables
variable "vpc_name"                 { default = "" }
variable "vpc_description"          { default = "" }
variable "vpc_cidr_block"           { default = "" }
variable "vpc_availability_zone"    { default = "" }
variable "vpc_inner_access_policy"  { default = "" }
variable "vpc_whitelist_ips"        { default = "" }
variable "vpc_sg_policy_ssh"        { default = "" }
variable "vpc_sg_policy_http"       { default = "" }
variable "vpc_sg_policy_https"      { default = "" }

# dns variables
variable "dns_group"            { default = "" }
variable "dns_domain_name"      { default = "" }
variable "dns_inc_value"        { default = "" }
variable "dns_www_value"        { default = "" }
variable "dns_develop_value"    { default = "" }
variable "dns_testing_value"    { default = "" }
variable "dns_staging_value"    { default = "" }
variable "dns_aliyundm_mail_value" { default = "" }
