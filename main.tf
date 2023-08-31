provider "aws" {
  region = "us-west-1"  
}

resource "aws_vpc" "nats_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.nats_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-1a"  
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.nats_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-1b"  
}

resource "aws_security_group" "nats_sg" {
  name_prefix = "nats-sg-"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4222
    to_port     = 4222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nats_instance" {
  count = 3
  ami           = "ami-053b0d53c279acc90" 
  instance_type = "t2.micro" 

  subnet_id        = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.nats_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y wget unzip
    wget https://github.com/nats-io/nats-server/releases/download/v2.6.2/nats-server-v2.6.2-linux-amd64.zip
    unzip nats-server-v2.6.2-linux-amd64.zip
    chmod +x nats-server-v2.6.2-linux-amd64/nats-server
    nohup ./nats-server-v2.6.2-linux-amd64/nats-server -p 4222 -cluster nats://0.0.0.0:6222 &
    EOF

  tags = {
    Name = "nats-server-${count.index}"
  }
}

resource "aws_network_acl" "public_subnet_acl" {
  subnet_ids = [aws_subnet.public_subnet.id]

  egress {
    protocol = "-1"
    rule_no  = 100
    action   = "allow"
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    protocol = "tcp"
    rule_no  = 100
    action   = "allow"
    from_port = 22
    to_port   = 22
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    protocol = "tcp"
    rule_no  = 200
    action   = "allow"
    from_port = 4222
    to_port   = 4222
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    protocol = "tcp"
    rule_no  = 300
    action   = "allow"
    from_port = 6222
    to_port   = 6222
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_network_acl" "private_subnet_acl" {
  subnet_ids = [aws_subnet.private_subnet.id]

  egress {
    protocol = "-1"
    rule_no  = 100
    action   = "allow"
    cidr_block = "0.0.0.0/0"
  }
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}
