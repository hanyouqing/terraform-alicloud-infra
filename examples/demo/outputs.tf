# @reference:
#   https://learn.hashicorp.com/terraform/getting-started/modules.html
# output "datasource" {
#     value = module.infra.datasource_dir
# }
output "datasource" {
    value = module.infra.datasource
}
output "vpc" {
    value = module.infra.vpc
}
output "dns-records" {
    value = module.infra.dns-records
}

# output "advertisement-motd" {
#     value = module.datasource.motd
# }
# output "module-datasource-alicloud_account_id" {
#     value = module.datasource.alicloud_account_id
# }
# output "module-datasource-datasource_dir" {
#     value = var.datasource_dir
# }
# output "module-datasource-regions" {
#     value = module.datasource.regions
# }
# output "module-datasource-region_alias" {
#     value = module.datasource.region_alias
# }
# output "module-datasource-cidr_blocks" {
#     value = module.datasource.cidr_blocks
# }
# output "vpc" {
#     value   = module.vpc.vpc
# }
# output "vswitch" {
#     value   = module.vpc.vswitch
# }
# output "sg" {
#     value   = module.vpc.sg
# }
# output "sg_rules" {
#     value   = module.vpc.sg_rules
# }
# module.dns.dns_records
# output "module-dns-dns_records" {
#     # value = module.dns.dns_records.*
#     value = formatlist(
#         "%v, %v, %v, %v, %v, %v, %v, %v, %v, %v", 
#         module.dns.dns_records.*.id,
#         module.dns.dns_records.*.name,
#         module.dns.dns_records.*.type,
#         module.dns.dns_records.*.host_record,
#         module.dns.dns_records.*.value,
#         module.dns.dns_records.*.ttl,
#         module.dns.dns_records.*.priority,
#         module.dns.dns_records.*.routing,
#         module.dns.dns_records.*.status,
#         module.dns.dns_records.*.locked,
#     )
# }