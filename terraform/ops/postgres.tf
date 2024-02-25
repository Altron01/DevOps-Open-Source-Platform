resource "huaweicloud_rds_instance" "ops_rds" {
  name              = "ops-rds"
  flavor            = "rds.pg.n1.large.2"
  vpc_id            = module.ops_data_vpc.vpc_id
  subnet_id         = module.ops_data_vpc.subnet_ids[0]
  security_group_id = huaweicloud_networking_secgroup.pods_to_rds_pg.id
  availability_zone = [data.huaweicloud_availability_zones.azs.names[0]]

  db {
    type     = "PostgreSQL"
    version  = "13"
    password = var.pg_root_pwd
  }

  volume {
    type = "CLOUDSSD"
    size = 100
  }
}

resource "huaweicloud_rds_pg_database" "harbor_db" {
  instance_id = huaweicloud_rds_instance.ops_rds.id
  name        = "harbor"
}

resource "huaweicloud_rds_pg_database" "keycloak_db" {
  instance_id = huaweicloud_rds_instance.ops_rds.id
  name        = "keycloak"
}

resource "huaweicloud_rds_pg_account" "harbor_user" {
  instance_id = huaweicloud_rds_instance.ops_rds.id
  name        = "harbor"
  password    = var.pg_user_pwd
}

resource "huaweicloud_rds_pg_account" "keycloak_user" {
  instance_id = huaweicloud_rds_instance.ops_rds.id
  name        = "keycloak"
  password    = var.pg_user_pwd
}