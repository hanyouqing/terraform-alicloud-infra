# @reference:
#   https://learn.hashicorp.com/terraform/getting-started/modules.html
output "datasource" {
    value = module.infra.datasource
}
output "vpc" {
    value = module.infra.vpc
}
output "dns-domain" {
    value = module.infra.dns-domain
}
output "dns-records" {
    value = module.infra.dns-records
}