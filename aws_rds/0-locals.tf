locals {
  env             = "dev"
  # profile         = "fiap"
  region          = "us-east-1"
  vpc_id          = "vpc-0590657dafcb00a4d"
  subnets_private = ["subnet-0e97d78732a476515", "subnet-02c79e6755258d97f"]
  subnets_public  = ["subnet-0a5c060e08564cb88", "subnet-0c0a93cd835f731f9"]
  sg_name = "rds-sg"
  rds_name = "processadordb"
  rds_engine = "postgres"
  rds_family = "postgres15"
  rds_engine_version = "15.10"
  rds_username = "postgres"
  rds_password = "lFLNzNzl5p*^"
}
