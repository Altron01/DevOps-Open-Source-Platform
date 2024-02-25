module "ops_vpc" {
  source = "../modules/terraform-huaweicloud-vpc"

  vpc_name       = "ops"
  vpc_cidr_block = "10.0.0.0/19"

  subnets_configuration = [
    {
      name="ops-internal",
      cidr="10.0.0.0/20"
    },
  ]

  is_security_group_create = false
}

module "ops_data_vpc" {
  source = "../modules/terraform-huaweicloud-vpc"

  vpc_name       = "ops-data"
  vpc_cidr_block = "172.16.0.0/16"

  subnets_configuration = [
    {
      name="ops-data",
      cidr="172.16.0.0/16"
    },
  ]

  is_security_group_create = false
}

resource "huaweicloud_networking_secgroup" "pods_to_rds_pg" {
  name        = "pods-to-rds-pg"
  description = "basic security group"
}

resource "huaweicloud_networking_secgroup_rule" "allow_pg_internal" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = "10.0.0.0/20"
  security_group_id = huaweicloud_networking_secgroup.pods_to_rds_pg.id
}

resource "huaweicloud_networking_secgroup_rule" "allow_pg_services" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = "10.0.48.0/20"
  security_group_id = huaweicloud_networking_secgroup.pods_to_rds_pg.id
}

resource "huaweicloud_networking_secgroup_rule" "allow_pg_pods" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = "10.0.32.0/20"
  security_group_id = huaweicloud_networking_secgroup.pods_to_rds_pg.id
}

resource "huaweicloud_networking_secgroup_rule" "allow_internal_data" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "172.16.0.0/16"
  security_group_id = huaweicloud_networking_secgroup.pods_to_rds_pg.id
}

resource "huaweicloud_vpc_peering_connection" "peering" {
  name        = "internal-to-data"
  vpc_id      = module.ops_vpc.vpc_id
  peer_vpc_id = module.ops_data_vpc.vpc_id
}

resource "huaweicloud_vpc_route" "route_ops_to_data" {
  vpc_id      = module.ops_vpc.vpc_id
  destination = "172.16.0.0/16"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.peering.id
}

resource "huaweicloud_vpc_route" "route_data_to_ops" {
  vpc_id      = module.ops_data_vpc.vpc_id
  destination = "10.0.0.0/18"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.peering.id
}