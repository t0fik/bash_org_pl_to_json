provider "aws" {
  region = "eu-central-1"
  profile = var.aws_profile
}


data "aws_availability_zones" "available" {}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.44.0"

  name                        = "jenkins-vpc"
  cidr                        = "10.10.0.0/16"
  azs                         = data.aws_availability_zones.available.names
  public_subnets              = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
  public_subnet_ipv6_prefixes = [0, 1, 2]

  enable_ipv6                                   = true
  assign_ipv6_address_on_creation               = true
  public_subnet_assign_ipv6_address_on_creation = true
}

module "sg" {
  source                   = "terraform-aws-modules/security-group/aws"
  version                  = "3.13.0"
  name                     = "restricted-sg"
  vpc_id                   = module.vpc.vpc_id
  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]
  ingress_rules = [
    "all-icmp",
    "http-80-tcp",
    "https-443-tcp",
    "http-8080-tcp",
    "ssh-tcp"
  ]
}
