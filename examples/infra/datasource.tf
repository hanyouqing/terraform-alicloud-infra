# @reference:
#   https://www.terraform.io/docs/configuration/data-sources.html
#   https://www.terraform.io/docs/providers/alicloud/index.html
#   https://www.terraform.io/docs/providers/alicloud/d/zones.html
#   https://www.terraform.io/docs/providers/alicloud/d/regions.html
#
locals {
    availability_zone   = "${lookup(var.icmdb-ecs, "region")}-${lookup(var.icmdb-ecs, "availability_zone")}"
}
data "alicloud_account" "current" {}
output "alicloud_account_id" {
    value               = "${data.alicloud_account.current.id}"
}
data "alicloud_regions" "regions" {
    output_file         = "${var.tf-jsondata}/regions.json"
}
# output "alicloud_regions_output" {
#     value               = "${formatlist("region-id: %v", data.alicloud_regions.regions.regions)}"
# }
data "alicloud_zones" "zone" {
    available_resource_creation = "Instance"
    # available_disk_category     = "cloud_efficiency"
    # available_instance_type     = ""
    output_file                 = "${var.tf-jsondata}/zones.${lookup(var.icmdb-ecs, "region")}.json"
}
data "alicloud_images" "ubuntu" {
    most_recent         = true
    name_regex          = "${lookup(var.icmdb-ecs, "img_ubuntu")}"
    output_file         = "${var.tf-jsondata}/img.ubuntu.json"
}
data "alicloud_images" "centos" {
    most_recent         = true
    name_regex          = "${lookup(var.icmdb-ecs, "img_centos")}"
    output_file         = "${var.tf-jsondata}/img.centos.json"
}
data "alicloud_instance_type_families" "prepaid" {
    instance_charge_type = "PrePaid"
    output_file          = "${var.tf-jsondata}/instance-types.prepaid.json"
}
data "alicloud_instance_type_families" "postpaid" {
    instance_charge_type = "PostPaid"
    output_file          = "${var.tf-jsondata}/instance-types.postpaid.json"
}
data "alicloud_instance_types" "instypes" {
    memory_size          = "${lookup(var.icmdb-ecs, "memory_size")}"
    cpu_core_count       = "${lookup(var.icmdb-ecs, "cpu_core_count")}"
    availability_zone    = "${local.availability_zone}"
    output_file          = "${var.tf-jsondata}/instance-types.${local.availability_zone}.json"
}

