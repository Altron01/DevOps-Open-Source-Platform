resource "huaweicloud_obs_bucket" "harbor_repo" {
  bucket = "hwc-harbor-registry-x2do"
  acl    = "private"

}