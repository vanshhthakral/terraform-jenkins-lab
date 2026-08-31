data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "web" {
  count                       = 2
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.web_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  metadata_options {
  http_endpoint = "enabled"
  http_tokens   = "required"
}

root_block_device {
  encrypted = true
}

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "advanced-iac-web-${count.index}"
  }
}

resource "aws_instance" "db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.db_sg_id]
  key_name               = var.key_name

  tags = {
    Name = "advanced-iac-db"
  }
  metadata_options {
  http_endpoint = "enabled"
  http_tokens   = "required"
}

root_block_device {
  encrypted = true
}
}
