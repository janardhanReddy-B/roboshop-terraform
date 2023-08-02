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

rabbitmq = {
  main = {
    instance_type = "t3.small"
    component     = "rabbitmq"
  }
}