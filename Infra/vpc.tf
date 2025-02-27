# Create a VPC
resource "aws_vpc" "stock_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "STOCK-VPC"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "stock_igw" {
  vpc_id = aws_vpc.stock_vpc.id

  tags = {
    Name = "STOCK-IGW"
  }
}

# Create a public route table
resource "aws_route_table" "stock_route_table" {
  vpc_id = aws_vpc.stock_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.stock_igw.id
  }

  tags = {
    Name = "STOCK-RT"
  }
}

# Associate the route table with subnets
resource "aws_route_table_association" "a" {
  count     = 3
  subnet_id = element(aws_subnet.stock_subnet.*.id, count.index)
  route_table_id = aws_route_table.stock_route_table.id
}

# Create subnets in different AZs
resource "aws_subnet" "stock_subnet" {
  count = 3
  vpc_id = aws_vpc.stock_vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = element(["eu-west-2a", "eu-west-2b", "eu-west-2c"], count.index)

  tags = {
    Name = "STOCK-SUBNET-${count.index + 1}"
  }
}