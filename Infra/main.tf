provider "aws" {
  region     = "eu-west-2"
  #access_key = var.AWS_ACCESS_KEY_ID
  #secret_key = var.AWS_SECRET_KEY_ID
}


# Create Security Group
resource "aws_security_group" "stock_sg" {
  vpc_id = aws_vpc.stock_vpc.id
  name   = "STOCK-SG"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
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
    Name = "STOCK-SG"
  }
}

# Create EC2 instances in each subnet with security group
resource "aws_instance" "stock_server" {
  count         = 3
  ami           = "ami-00710ab5544b60cf7"
  instance_type = "t2.micro"
  key_name      = "Ans-Auth"
  subnet_id     = "${aws_subnet.stock_subnet[count.index].id}"
  vpc_security_group_ids = ["${aws_security_group.stock_sg.id}"]
  tags = {
    Name = "STOCK-SERVER-${count.index + 1}"
  }
}

# Create inventory file using private IPs
resource "local_file" "inventory_ini" {
  content  = <<-EOF
  [REPLICA]
  %{ for ip in aws_instance.stock_server.*.public_ip }
  ${ip}
  %{ endfor }
  EOF
  filename = "${path.module}/inventory.ini"
}


