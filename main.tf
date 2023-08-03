
module "vpc" {
  source = "git::https://github.com/janardhanReddy-B/tf-module-vpc-b.git"

  for_each   = var.vpc
  cidr_block = each.value["cidr_block"]
  subnets    = each.value["subnets"]

  env            = var.env
  tags           = var.tags
  default_vpc_id = var.default_vpc_id
  default_vpc_rt = var.default_vpc_rt

}

module "rabbitmq" {
  source = "git::https://github.com/janardhanReddy-B/tf-module-rabbitmq-b.git"

  for_each      = var.rabbitmq
  component     = each.value["component"]
  instance_type = each.value["instance_type"]

  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.vpc, "main", null), "subnets", null), "app", null), "cidr_block", null)
  vpc_id         = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  subnet_id      = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet_ids", null), "db", null), "subnet_ids", null)[0]

  env            = var.env
  tags           = var.tags
  allow_ssh_cidr = var.allow_ssh_cidr
  zone_id        = var.zone_id
}

module "rds" {
  source = "git::https://github.com/janardhanReddy-B/tf-module-rds-b.git"

  for_each       = var.rds
  component      = each.value["component"]
  engine         = each.value["engine"]
  engine_version = each.value["engine_version"]
  db_name        = each.value["db_name"]
  subnet_ids     = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet_ids", null), "db", null), "subnet_ids", null)
  instance_count = each.value["instance_count"]
  instance_class = each.value["instance_class"]
  vpc_id         = lookup(lookup(module.vpc, "main", null), "vpc_id", null)

  tags           = var.tags
  env            = var.env
  kms_key_arn    = var.kms_key_arn
  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.vpc, "main", null), "subnets", null), "app", null), "cidr_block", null)

}

module "documentdb" {
  source = "git::https://github.com/janardhanReddy-B/tf-module-documentdb-b.git"

  for_each          = var.documentdb
  component         = each.value["component"]
  subnet_ids        = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet_ids", null), "db", null), "subnet_ids", null)
  vpc_id            = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  sg_subnet_cidr    = lookup(lookup(lookup(lookup(var.vpc, "main", null), "subnets", null), "app", null), "cidr_block", null)
  engine            = each.value["engine"]
  engine_version    = each.value["engine_version"]
  db_instance_count = each.value["db_instance_count"]
  instance_class    = each.value["instance_class"]

  tags        = var.tags
  env         = var.env
  kms_key_arn = var.kms_key_arn
}

module "elasticache" {
  source = "git::https://github.com/janardhanReddy-B/tf-module-elasticache-b.git"

  for_each                = var.elasticache
  component               = each.value["component"]
  subnet_ids              = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet_ids", null), "db", null), "subnet_ids", null)
  engine                  = each.value["engine"]
  engine_version          = each.value["engine_version"]
  replicas_per_node_group = each.value["replicas_per_node_group"]
  num_node_groups         = each.value["num_node_groups"]
  vpc_id                  = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  sg_subnet_cidr          = lookup(lookup(lookup(lookup(var.vpc, "main", null), "subnets", null), "app", null), "cidr_block", null)
  node_type               = each.value["node_type"]
  parameter_group_name    = each.value["parameter_group_name"]

  tags        = var.tags
  env         = var.env
  kms_key_arn = var.kms_key_arn
}

module "alb" {
  source = "git::https://github.com/janardhanReddy-B/tf-module-alb-b.git"

  for_each           = var.alb
  name               = each.value["name"]
  internal           = each.value["internal"]
  load_balancer_type = each.value["load_balancer_type"]
  vpc_id             = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  sg_subnet_cidr     = each.value["name"] == "public" ? ["0.0.0.0/0"] : local.app_web_subnet_cidr
  subnets            = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet_ids", null), each.value["subnet_ref"], null), "subnet_ids", null)

  env  = var.env
  tags = var.tags
}