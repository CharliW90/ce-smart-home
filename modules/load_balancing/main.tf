# Create different target groups for the services

data "aws_instances" "public_apps_as_instance" {
  count = length(var.public_apps)

  instance_tags = {
    "Name" = "${var.public_apps[count.index]}-*"
  }
}

resource "aws_lb_target_group" "public_tg" {
  count = length(var.public_apps)

  vpc_id = var.main_vpc_id

  protocol = var.public_tg_protocol
  protocol_version = var.public_tg_protocol_version
  port = var.public_tg_port

  health_check {
    path = var.health_check_path
    protocol = var.health_check_protocol
  }

  tags = {
    Name = "${var.public_apps[count.index]}-public-tg"
    ManagedBy = "Terraform"
  }
}

resource "aws_lb_target_group_attachment" "public_tg_attachment" {
  count = length(var.public_apps) * length(data.aws_instances.public_apps_as_instance)
  target_id = data.aws_instances.public_apps_as_instance[floor(count.index / length(data.aws_instances.public_apps_as_instance))].ids[count.index % length(data.aws_instances.public_apps_as_instance)]
  target_group_arn = aws_lb_target_group.public_tg[floor(count.index / length(data.aws_instances.public_apps_as_instance))].arn
}

data "aws_instances" "private_apps_as_instance" {
  count = length(var.private_apps)

  instance_tags = {
    "Name" = "${var.private_apps[count.index]}-*"
  }
}

resource "aws_lb_target_group" "private_tg" {
  count = length(var.private_apps)

  vpc_id = var.main_vpc_id

  protocol = var.private_tg_protocol
  protocol_version = var.private_tg_protocol_version
  port = var.private_tg_port


  tags = {
    Name = "${var.private_apps[count.index]}-private-tg"
    ManagedBy = "Terraform"
  }
}

resource "aws_lb_target_group_attachment" "private_tg_attachment" {
  count = length(var.private_apps) * length(data.aws_instances.private_apps_as_instance)
  target_id = data.aws_instances.private_apps_as_instance[floor(count.index / length(data.aws_instances.private_apps_as_instance))].ids[count.index % length(data.aws_instances.private_apps_as_instance)]
  target_group_arn = aws_lb_target_group.private_tg[floor(count.index / length(data.aws_instances.private_apps_as_instance))].arn
}

# Add load balancing