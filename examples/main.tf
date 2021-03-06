provider "aws" {
  version = "~> 1.2"
  region  = "us-west-2"
}

module "base_network" {
  source   = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork?ref=v0.0.6"
  vpc_name = "SG-VPC-TEST"
}

module "test_sg" {
  source        = "git@github.com:rackspace-infrastructure-automation/aws-terraform-security_group?ref=v0.0.6"
  resource_name = "my_test_sg"
  vpc_id        = "${module.base_network.vpc_id}"
}

# Lookup the correct AMI based on the region specified
data "aws_ami" "amazon_centos_7" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }
}

data "aws_region" "current_region" {}

module "ec2_ar_database" {
  source         = "git@github.com:rackspace-infrastructure-automation/aws-terraform-ec2_autorecovery?ref=v0.0.6"
  ec2_os         = "centos7"
  instance_count = "3"
  subnets        = ["${module.base_network.private_subnets}"]

  ### Example security group module reference
  security_group_list = ["${module.test_sg.public_ssh_security_group_id}"]

  image_id                     = "${data.aws_ami.amazon_centos_7.image_id}"
  key_pair                     = "CircleCI"
  instance_type                = "t2.micro"
  resource_name                = "ec2_ar_db_access"
  tenancy                      = "default"
  primary_ebs_volume_size      = "60"
  primary_ebs_volume_iops      = "0"
  primary_ebs_volume_type      = "gp2"
  encrypt_secondary_ebs_volume = "False"
  environment                  = "Development"
}
