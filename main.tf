/**
 * # aws-terraform-security_group
 *
 *This module creates the standard security groups for use on an account.
 *
 *## Basic Usage
 *
 *```
 *module "security_groups" {
 *  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-security_group//?ref=v0.0.1"
 *
 *  resource_name = "Test-SG"
 *  vpc_id        = "${module.vpc.vpc_id}"
 *  environment   = "Production"
 *}
 *```
 */

locals {
  tags = {
    Environment     = "${var.environment}"
    ServiceProvider = "Rackspace"
  }
}

data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

resource "aws_security_group" "public_ssh_security_group" {
  name_prefix = "${var.resource_name}-PublicSSHSecurityGroup"
  description = "Public SSH Security Group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = "${merge(local.tags, map("Name", "${var.resource_name}-PublicSSHSecurityGroup"))}"
}

resource "aws_security_group" "private_ssh_security_group" {
  name_prefix = "${var.resource_name}-PrivateSSHSecurityGroup"
  description = "Private SSH Security Group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.public_ssh_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = "${merge(local.tags, map("Name", "${var.resource_name}-PrivateSSHSecurityGroup"))}"
}

resource "aws_security_group" "public_web_security_group" {
  name_prefix = "${var.resource_name}-PublicWebSecurityGroup"
  description = "Public Web Security Group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = "${merge(local.tags, map("Name", "${var.resource_name}-PublicWebSecurityGroup"))}"
}

resource "aws_security_group" "private_web_security_group" {
  name_prefix = "${var.resource_name}-PrivateWebSecurityGroup"
  description = "Private Web Security Group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.public_web_security_group.id}"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["${aws_security_group.public_web_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = "${merge(local.tags, map("Name", "${var.resource_name}-PrivateWebSecurityGroup"))}"
}

