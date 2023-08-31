provider "aws" {
  region = "us-east-1"  #
}

# Create a VPC
resource "aws_vpc" "nas-vpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "nats-subnet" {
  vpc_id     = aws_vpc.nas-vpc.id
  cidr_block = "10.0.0.0/24"
}

# Create a security group for the  NATS servers
resource "aws_security_group" "nats_sg" {
  name_prefix = "nats-sg-"

  # Define security group rules for NATS ports (4222, 6222, 8222)
  ingress {
    from_port = 4222
    to_port   = 4222
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # monitoring 
  ingress {
    from_port = 8222
    to_port   = 8222
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
}

# Create NATS instances
resource "aws_instance" "nats" {
  count = 3  # Number of NATS instances

  ami           = "ami-053b0d53c279acc90"  # Your desired NATS instance AMI ID
  instance_type = "t2.micro"      # Your desired instance type
  vpc_security_group_ids = [aws_security_group.nats_sg.id]


  user_data = <<-EOF
    #!/bin/bash
    curl -LO https://github.com/nats-io/nats-server/releases/download/v2.6.0/nats-server-v2.6.0-linux-amd64.zip
    unzip nats-server-v2.6.0-linux-amd64.zip
    mv nats-server-v2.6.0-linux-amd64 /usr/local/bin/nats-server
    rm nats-server-v2.6.0-linux-amd64.zip

    # Create a configuration file for NATS
    echo "Creating NATS configuration..."
    cat <<EOF > /etc/nats.conf
    port: 4222
    port: 4222

    # HTTP monitoring port
    monitor_port: 8222

    # This is for clustering multiple servers together.
    cluster {
    # It is recommended to set a cluster name
    name: "nats-demo"
    }
    echo "Starting NATS server..."
    nats-server -c /path/to/nats.conf 
  EOF
  
}