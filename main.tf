#module "instances" {
#  for_each = var.components
#  source = "git::https://github.com/janardhanReddy-B/tf-module-app.git"
#  component = each.key
#  env = var.env
#  tags = merge(each.value["tags"], var.tags)
#
#}

module "vpc" {
  source = "git::https://github.com/janardhanReddy-B/tf-module-vpc-b.git"
  for_each   = var.vpc
  cidr_block = each.value["cidr_block"]
  subnets    = each.value["subnets"]
  env            = var.env
  tags           = var.tags
}