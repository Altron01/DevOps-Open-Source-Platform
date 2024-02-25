data "huaweicloud_availability_zones" "azs" {}

data "huaweicloud_vpc" "ops_vpc" {
  name = "ops"
}