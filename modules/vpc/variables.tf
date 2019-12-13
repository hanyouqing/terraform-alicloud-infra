variable "region"       { default = "" } # takes region id as workspace name
variable "region_abbr"  { default = "" }
variable "environment"  { default = "" } # dev|test|stag|prod
variable "department"   { default = "" }
variable "project"      { default = "" }
variable "createby"     { default = "" }
variable "owner"        { default = "" }
variable "provisioner"  { default = "" }


variable "vpc_name"                 { default = "" }
variable "vpc_description"          { default = "" }
variable "vpc_cidr_block"           { default = "" } # 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
variable "vpc_availability_zone"    { default = "" }
variable "vpc_inner_access_policy"  { default = "" }
variable "vpc_whitelist_ips"        { default = "" }
variable "vpc_sg_policy_ssh"        { default = "" }
variable "vpc_sg_policy_http"       { default = "" }
variable "vpc_sg_policy_https"      { default = "" }