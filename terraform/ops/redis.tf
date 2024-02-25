data "huaweicloud_dcs_flavors" "single_flavors" {
  cache_mode = "single"
  capacity   = 1
}

# 1.2 Create Single-node Redis instance
resource "huaweicloud_dcs_instance" "ops_redis" {
  name           = "ops-redis"
  engine         = "Redis"
  engine_version = "6.0"
  capacity       = data.huaweicloud_dcs_flavors.single_flavors.capacity
  flavor         = data.huaweicloud_dcs_flavors.single_flavors.flavors[0].name

  availability_zones = [
    data.huaweicloud_availability_zones.azs.names[0]
  ]
  vpc_id        = module.ops_data_vpc.vpc_id
  subnet_id     = module.ops_data_vpc.subnet_ids[0]
  password      = var.redis_root_pwd
  charging_mode = "postPaid"

  whitelists {
    group_name = "pods"
    ip_address = ["10.0.32.0/20", "10.0.0.0/20", "10.0.48.0/20"]
  }
}