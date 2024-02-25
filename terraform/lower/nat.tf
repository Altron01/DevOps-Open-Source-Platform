resource "huaweicloud_vpc_eip" "lower_nat_eip" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "lower-eip"
    size        = 300
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "huaweicloud_nat_gateway" "nat_gateway" {
  name                = "lower-nat"
  description         = "example for net test"
  spec                = "1"
  vpc_id           = module.lower_vpc.vpc_id
  subnet_id = module.lower_vpc.subnet_ids[0]
}

resource "huaweicloud_nat_snat_rule" "snat" {
  nat_gateway_id = huaweicloud_nat_gateway.nat_gateway.id
  subnet_id     = module.lower_vpc.subnet_ids[0]
  floating_ip_id = huaweicloud_vpc_eip.lower_nat_eip.id
}