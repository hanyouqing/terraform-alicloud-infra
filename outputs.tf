# @reference:
#   https://learn.hashicorp.com/terraform/getting-started/modules.html

output "datasource" {
    value = {
        "advertisement": module.datasource.motd,
        "alicloud_account_id": module.datasource.alicloud_account_id,
        # "datasource_dir": module.datasource.datasource_dir,
        "regions": module.datasource.regions,
        "region_alias": module.datasource.region_alias,
        "cidr_blocks": module.datasource.cidr_blocks,
    }
}
output "vpc" {
    value = {
        "vpc": module.vpc.vpc,
        "vswitch": module.vpc.vswitch,
        "sg": module.vpc.sg,
        "sgrules": formatlist("%v, %v", module.vpc.sg_rules.*.id, module.vpc.sg_rules.*.name),
    }
}
output "dns-records" {
    # value = module.dns.dns_records.*
    value = formatlist(
        "%v, %v, %v, %v, %v, %v, %v, %v, %v, %v", 
        module.dns.dns_records.*.id,
        module.dns.dns_records.*.name,
        module.dns.dns_records.*.type,
        module.dns.dns_records.*.host_record,
        module.dns.dns_records.*.value,
        module.dns.dns_records.*.ttl,
        module.dns.dns_records.*.priority,
        module.dns.dns_records.*.routing,
        module.dns.dns_records.*.status,
        module.dns.dns_records.*.locked,
    )
}