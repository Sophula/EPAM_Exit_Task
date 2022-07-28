module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  tags = {
    Name = "main-vpc"
  }
}

module "nat" {
  source = "github.com/int128/terraform-aws-nat-instance"

  name                        = "nat-instance"
  vpc_id                      = module.vpc.vpc_id
  public_subnet               = module.vpc.public_subnets[0]
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks

  private_route_table_ids = module.vpc.private_route_table_ids
}

resource "aws_key_pair" "bastion" {
  key_name = "bastion-key-pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_configuration" "bastion" {
    image_id = data.aws_ami.amazon-linux-2.id
    instance_type = var.instance_type
    key_name = aws_key_pair.bastion.key_name
    associate_public_ip_address = var.associate_public_ip_address
    security_groups = [aws_security_group.allow_ssh_to_bastion.id
  ]
}

resource "aws_security_group" "allow_ssh_to_bastion" {
  name = "allow-ssh-to-bastion-host"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "allow-ssh-to-bastion-host"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.egress_cidrs
  }
}

resource "aws_security_group" "allow_ssh_from_bastion" {
  name = "allow-ssh-from-bastion"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "allow-ssh-from-bastion"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.allow_ssh_to_bastion.id]
  }
}