module "lower_cluster" {
  source = "../modules/terraform-huaweicloud-cce"

  vpc_id             = module.lower_vpc.vpc_id
  subnet_id          = module.lower_vpc.subnet_ids[0]
  availability_zones = [ data.huaweicloud_availability_zones.azs.names[0], data.huaweicloud_availability_zones.azs.names[1], data.huaweicloud_availability_zones.azs.names[1] ]

  cluster_type           = "VirtualMachine"
  cluster_version           = "v1.27"
  cluster_flavor         = "cce.s2.small"
  container_network_type = "vpc-router"
  container_network_cidr = "10.1.32.0/20"
  service_network_cidr   = "10.1.48.0/20"
  cluster_public_access  = false
  cluster_name           = "lower-cluster"
  is_delete_all          = true

  nodes_configuration = [
    {
      name               = "lower-control"
      flavor_id          = "s6.large.2"
      initial_node_count = 3
      os                 = "EulerOS 2.9"
      password           = var.cce_node_pwd
      tags = {
        Creator = "terraform"
      }

      root_volumes = [{
        type = "SAS"
        size = 50
      }]

      data_volumes = [{
        type = "SAS"
        size = 100
      }]
    }
  ]

  node_pools_configuration = [
    {
      name               = "lower-primary"
      initial_node_count = 2
      min_node_count = 2
      max_node_count = 3
      flavor_id          = "s6.large.2"
      os                 = "EulerOS 2.9"
      password           = var.cce_node_pwd
      tags = {
        Creator = "terraform"
      }
      
      root_volumes = [{
        type = "SAS"
        size = 50
      }]

      data_volumes = [{
        type = "SAS"
        size = 100
      }]
    }
  ]
}