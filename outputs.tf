# @reference:
#   https://learn.hashicorp.com/terraform/getting-started/modules.html
output "motd" {
    value = var.motd
}

output "vpc" {
    value = {
        "vpc_name": "${module.vpc.name}",
        "vpc_sg": "${module.vpc.sg}",
        "vpc_whitelist": "${module.vpc.whitelist}",
    }
}
