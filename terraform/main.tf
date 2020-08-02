provider "aws" {
  region = "eu-central-1"
}


data "aws_availability_zones" "available" {}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.44.0"

  name           = "jenkins-vpc"
  cidr           = "10.10.0.0/16"
  azs            = data.aws_availability_zones.available.names
  public_subnets = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
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
  ingress_rules            = ["https-443-tcp", "http-80-tcp"]
  ingress_with_cidr_blocks = [
    {
      description = "Bash scraping service"
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
    },
  ]
  ingress_with_ipv6_cidr_blocks = [
    {
      description = "Bash scraping service"
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
    },
  ]
}

module "ec2" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "2.15.0"
  name                        = "jenkins"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  ami                         = "ami-0c115dbd34c69a004"
  subnet_ids                  = module.vpc.public_subnets
  vpc_security_group_ids      = [module.sg.this_security_group_id]
}
