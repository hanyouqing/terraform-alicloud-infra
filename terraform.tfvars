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

motd         = [
    "+++++++++++++++++++++++++++++++++++++++++++++++++++++",
    "+                                                   +",
    "+   The motd is just a advertisement.               +",
    "+   I'm sorry about that, but we really need you.   +",
    "+   If you are interested, email me please!         +",
    "+                                                   +",
    "+                      --- ihanyouqing@gmail.com    +",
    "+                                                   +",
    "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
]

# common variables
region       = "cn-beijing"
region_abbr  = "bj"
environment  = "testing"
department   = "tech"
project      = "icmdb"
owner        = "icmdb"
createby     = "ihanyouqing@gmail.com"
provisioner  = "terraform"

# vpc variables
vpc_name                = "icmdb"
vpc_description         = "icmdb"
vpc_availability_zone   = "cn-beijing-e"
vpc_inner_access_policy = "Drop"            # Accept|Drop, allow from all in the same security group
vpc_whitelist_ips       = "106.38.171.130"
vpc_sg_policy_ssh       = "accept"          # accept|drop
vpc_sg_policy_http      = "accept"
vpc_sg_policy_https     = "drop"
