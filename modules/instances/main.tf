# Create EC2 per application (4)

resource "aws_instance" "public_app" {
  count = length(var.public_apps)

  ami = data.aws_ami.latest_ubuntu.id

  instance_type = var.instance_type

  subnet_id = var.public_subnets[count.index]

  associate_public_ip_address = true

  key_name = var.keyPair
  
  tags = {
    Name = var.public_apps[count.index]
  }
}

resource "aws_instance" "private_app" {
  count = length(var.private_apps)

  ami = data.aws_ami.latest_ubuntu.id

  instance_type = var.instance_type

  subnet_id = var.private_subnets[count.index]

  associate_public_ip_address = false

  key_name = var.keyPair
  
  tags = {
    Name = var.private_apps[count.index]
  }
}

data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
}