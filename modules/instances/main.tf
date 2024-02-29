# Create EC2 per application (4)

resource "aws_instance" "public_app" {
  count = length(var.public_apps) * length(var.public_subnets)

  ami = data.aws_ami.latest_ubuntu.id

  instance_type = var.instance_type

  subnet_id = var.public_subnets[count.index % length(var.public_subnets)] # 0,1,2 ...

  security_groups = var.public_security_group_ids

  associate_public_ip_address = true

  key_name = var.keyPair

  tags = {
    Name = "${var.public_apps[(floor(count.index / length(var.public_apps)) % length(var.public_apps))]}-${count.index % length(var.public_subnets)}"
  }
}

resource "aws_instance" "private_app" {
  count = length(var.private_apps) * length(var.private_subnets)

  ami = data.aws_ami.latest_ubuntu.id

  instance_type = var.instance_type

  subnet_id = var.private_subnets[count.index % length(var.private_subnets)] #0,1,2 ...

  associate_public_ip_address = false

  security_groups = var.private_security_group_ids

  key_name = var.keyPair

  tags = {
    Name = "${var.private_apps[(floor(count.index / length(var.private_apps)) % length(var.private_apps))]}-${count.index % length(var.private_subnets)}"
  }
}

data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_secretsmanager_secret" "github" {
  name = "GIT_ACCESS_TOKEN"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.github.id
}

resource "null_resource" "init_public_instances" {
  depends_on = [ aws_instance.private_app, aws_instance.public_app ]
  count = length(aws_instance.public_app[*])

  connection {
    type = "ssh"
    host = aws_instance.public_app[count.index].public_dns
    user = "ubuntu"
    private_key = file("~/.ssh/${var.keyPair}.pem")
  }

  # provisioner "file" {
  #   content = <<EOF
  #     #!/bin/bash
  #     curl -q -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
  #     . ~/.nvm/nvm.sh
  #     nvm install --lts
  #     npm install pm2@latest -g
  #     git clone -u $1 $2
  #     cd $3
  #     pm2 start npm -- run start
  #   EOF
  #   destination = "./init.sh"
  # }

  provisioner "remote-exec" {
    inline = [
      "curl -q -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash",
      ". ~/.nvm/nvm.sh",
      "nvm install --lts",
      "npm install pm2@latest -g",
      # "git clone -u ${data.aws_secretsmanager_secret_version.current.secret_string} ${var.root_github_owner}/${var.private_apps[(floor(count.index / length(var.private_apps)) % length(var.private_apps))]}.git",
      # "ls",
      # "cd ${var.private_apps[(floor(count.index / length(var.private_apps)) % length(var.private_apps))]}/",
      # "pm2 start npm -- run start"
    ]
  }
}

# "bash init.sh GIT_ACCESS_TOKEN='${data.aws_secretsmanager_secret_version.current.secret_string}' APP_URL='${var.root_github_owner}/${var.private_apps[(floor(count.index / length(var.private_apps)) % length(var.private_apps))]}.git' APP_NAME='${var.private_apps[(floor(count.index / length(var.private_apps)) % length(var.private_apps))]}/'"