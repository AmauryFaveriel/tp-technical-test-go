provider "aws" {
  version = "~> 2.0"
  region = "eu-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "ssh_key" {
  public_key = file(var.public_ssh_key_file)
  key_name = "technical-test-tp-ssh-key"
}

module "staging" {
  source = "./application"

  instance_ami = data.aws_ami.ubuntu.id
  stage = "staging"
  instance_key_name = aws_key_pair.ssh_key.key_name
}