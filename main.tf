provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "week2_task" {
  ami                         = "ami-0134dde2b68fe1b07"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.week2_task.id]
  key_name                    = aws_key_pair.ssh_key.key_name
  user_data                   = file("./install.sh")

  tags = {
    name  = "Docker&Docker-Compose instance"
    owner = "Sergiy Ladygin"
  }
}

resource "aws_security_group" "week2_task" {
  name = "Docker&Docker-Compose security group"
  # description = ""

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["213.109.128.0/20"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
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

  tags = {
    name  = "Docker&Docker-Compose security group"
    owner = "Sergiy Ladygin"
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}
