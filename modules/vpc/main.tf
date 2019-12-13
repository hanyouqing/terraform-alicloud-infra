# @reference:
#   https://www.terraform.io/docs/providers/alicloud/r/vpc.html
#   https://www.terraform.io/docs/providers/alicloud/r/vswitch.html
#   https://www.terraform.io/docs/providers/alicloud/r/security_group.html
#   https://www.terraform.io/docs/providers/alicloud/r/security_group_rule.html
#   

resource "alicloud_vpc" "icmdb" {
    name               = var.vpc_name
    description        = var.vpc_description
    cidr_block         = var.vpc_cidr_block
    tags = {
        environment    = var.environment
        department     = var.department
        project        = var.project
        createby       = var.createby
        owner          = var.owner
        provisioner    = var.provisioner
    }

    lifecycle {
        ignore_changes = [route_table_id, router_id, router_table_id]
    }
}
resource "alicloud_vswitch" "icmdb" {
    name                = format("vsw-%v", var.vpc_name)
    cidr_block          = var.vpc_cidr_block
    availability_zone   = var.vpc_availability_zone
    vpc_id              = alicloud_vpc.icmdb.id
}
resource "alicloud_security_group" "icmdb" {
    name                = format("sg-%v", var.vpc_name)
    vpc_id              = alicloud_vpc.icmdb.id
    inner_access_policy = var.vpc_inner_access_policy   # Accept|Drop # allow to access each other on all ports in the same security group
}
resource "alicloud_security_group_rule" "icmdb" {
    type                = "ingress"
    ip_protocol         = "tcp"
    port_range          = "1/65535"
    nic_type            = "intranet"
    cidr_ip             = var.vpc_whitelist_ips
    policy              = "accept"
    priority            = 10
    security_group_id   = alicloud_security_group.icmdb.id
    lifecycle {
        ignore_changes = [id]
    }
}
resource "alicloud_security_group_rule" "default" {
    type                = "ingress"
    ip_protocol         = "tcp"
    port_range          = "1/65535"
    nic_type            = "intranet"
    cidr_ip             = "0.0.0.0/0"
    policy              = "drop"
    priority            = 100
    security_group_id   = alicloud_security_group.icmdb.id
    lifecycle {
        ignore_changes = [id]
    }
}
resource "alicloud_security_group_rule" "ssh" {
    type                = "ingress"
    ip_protocol         = "tcp"
    port_range          = "22/22"
    nic_type            = "intranet"
    cidr_ip             = "0.0.0.0/0"
    policy              = var.vpc_sg_policy_ssh
    priority            = 90
    security_group_id   = alicloud_security_group.icmdb.id
    lifecycle {
        ignore_changes = [id]
    }
}
resource "alicloud_security_group_rule" "http" {
    type                = "ingress"
    ip_protocol         = "tcp"
    port_range          = "80/80"
    nic_type            = "intranet"
    cidr_ip             = "0.0.0.0/0"
    policy              = var.vpc_sg_policy_http
    priority            = 90
    security_group_id   = alicloud_security_group.icmdb.id
    lifecycle {
        ignore_changes = [id]
    }
}
resource "alicloud_security_group_rule" "https" {
    type                = "ingress"
    ip_protocol         = "tcp"
    port_range          = "443/443"
    nic_type            = "intranet"
    cidr_ip             = "0.0.0.0/0"
    policy              = var.vpc_sg_policy_https
    priority            = 90
    security_group_id   = alicloud_security_group.icmdb.id
    lifecycle {
        ignore_changes = [id]
    }
}