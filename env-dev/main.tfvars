env = "dev"

tags = {
  company_name  = "XYZ Tech"
  business      = "ecommerce"
  business_unit = "retail"
  cost_center   = "322"
  project_name  = "roboshop"
}


vpc = {
  main = {
    cidr_block = "10.0.0.0/16"
    subnets = {
      web    = { cidr_block = ["10.0.0.0/24", "10.0.1.0/24"] }
      app    = { cidr_block = ["10.0.2.0/24", "10.0.3.0/24"] }
      db     = { cidr_block = ["10.0.4.0/24", "10.0.5.0/24"] }
      public = { cidr_block = ["10.0.6.0/24", "10.0.7.0/24"] }
    }
  }
}

default_vpc_id        = "vpc-033afb10db1e6a9da"
default_vpc_rt        = "rtb-0ba2f25e4527ec7d1"
allow_ssh_cidr        = ["172.31.94.211/32"]
zone_id               = "Z03052753T4U1K1QH805F"
kms_key_id            = "2eeb6c9c-36f5-4e89-857c-680ad8eedf3e"
kms_key_arn           = "arn:aws:kms:us-east-1:637261222008:key/2eeb6c9c-36f5-4e89-857c-680ad8eedf3e"
allow_prometheus_cidr = ["172.31.13.150/32"]

rabbitmq = {
  main = {
    instance_type = "t3.small"
    component     = "rabbitmq"
  }
}

rds = {
  main = {
    component      = "rds"
    engine         = "aurora-mysql"
    engine_version = "5.7.mysql_aurora.2.11.3"
    db_name        = "dummy"
    instance_count = 1
    instance_class = "db.t3.small"
  }
}

documentdb = {
  main = {
    component         = "docdb"
    engine            = "docdb"
    engine_version    = "4.0.0"
    db_instance_count = 1
    instance_class    = "db.t3.medium"
  }
}

elasticache = {
  main = {
    component               = "elasticache"
    engine                  = "redis"
    engine_version          = "6.x"
    replicas_per_node_group = 1
    num_node_groups         = 1
    node_type               = "cache.t3.micro"
    parameter_group_name    = "default.redis6.x.cluster.on"
  }
}

alb = {
  public = {
    name               = "public"
    internal           = false
    load_balancer_type = "application"
    subnet_ref         = "public"
  }
  private = {
    name               = "private"
    internal           = true
    load_balancer_type = "application"
    subnet_ref         = "app"
  }
}

apps = {
  cart = {
    component        = "cart"
    app_port         = 8080
    instance_type    = "t3.small"
    desired_capacity = 2
    max_size         = 5
    min_size         = 2
    subnet_ref       = "app"
    lb_ref           = "private"
    lb_rule_priority = 100
  }
  catalogue = {
    component          = "catalogue"
    app_port           = 8080
    instance_type      = "t3.small"
    desired_capacity   = 2
    max_size           = 5
    min_size           = 2
    subnet_ref         = "app"
    lb_ref             = "private"
    lb_rule_priority   = 101
    extra_param_access = ["arn:aws:ssm:us-east-1:637261222008:parameter/roboshop.dev.docdb.*"]
  }
  user = {
    component          = "user"
    app_port           = 8080
    instance_type      = "t3.small"
    desired_capacity   = 2
    max_size           = 5
    min_size           = 2
    subnet_ref         = "app"
    lb_ref             = "private"
    lb_rule_priority   = 102
    extra_param_access = ["arn:aws:ssm:us-east-1:637261222008:parameter/roboshop.dev.docdb.*"]
  }
  shipping = {
    component          = "shipping"
    app_port           = 8080
    instance_type      = "t3.small"
    desired_capacity   = 2
    max_size           = 5
    min_size           = 2
    subnet_ref         = "app"
    lb_ref             = "private"
    lb_rule_priority   = 103
    extra_param_access = ["arn:aws:ssm:us-east-1:637261222008:parameter/roboshop.dev.mysql.*"]
  }
  payment = {
    component        = "payment"
    app_port         = 8080
    instance_type    = "t3.small"
    desired_capacity = 2
    max_size         = 5
    min_size         = 2
    subnet_ref       = "app"
    lb_ref           = "private"
    lb_rule_priority = 104
  }
  frontend = {
    component        = "frontend"
    app_port         = 80
    instance_type    = "t3.small"
    desired_capacity = 2
    max_size         = 7
    min_size         = 2
    subnet_ref       = "web"
    lb_ref           = "public"
    lb_rule_priority = 100
  }
}