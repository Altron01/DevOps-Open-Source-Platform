module "lower_vpc" {
  source = "../modules/terraform-huaweicloud-vpc"

  vpc_name       = "lower"
  vpc_cidr_block = "10.1.0.0/19"

  subnets_configuration = [
    {
      name="lower-internal",
      cidr="10.1.0.0/20"
    },
  ]

  is_security_group_create = false
}

resource "huaweicloud_vpc_peering_connection" "peering" {
  name        = "lower-to-ops"
  vpc_id      = module.lower_vpc.vpc_id
  peer_vpc_id = data.huaweicloud_vpc.ops_vpc.id
}

resource "huaweicloud_vpc_route" "route_lower_to_ops" {
  vpc_id      = module.lower_vpc.vpc_id
  destination = "10.0.0.0/18"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.peering.id
}

resource "huaweicloud_vpc_route" "route_ops_to_lower" {
  vpc_id      = data.huaweicloud_vpc.ops_vpc.id
  destination = "10.1.0.0/18"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.peering.id
}