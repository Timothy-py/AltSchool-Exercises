# CREATE A VPC RESOURCE
resource "aws_vpc" "altschool" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "altschool-vpc"
  }
}

# CREATE A SUBNET RESOURCE
resource "aws_subnet" "altschool" {
  vpc_id                  = aws_vpc.altschool.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-1b"

  tags = {
    Name = "altschool-public"
  }
}

# CREATE AN INTERNET GATEWAY RESOUCE
resource "aws_internet_gateway" "altschool" {
  vpc_id = aws_vpc.altschool.id

  tags = {
    Name = "altschool-igw"
  }
}

# CREATE AWS ROUTE TABLE
resource "aws_route_table" "altschool" {
  vpc_id = aws_vpc.altschool.id

  tags = {
    Name = "altschool-rt"
  }
}

# CREATE AWS ROUTE RESOURCE
resource "aws_route" "altschool" {
  route_table_id         = aws_route_table.altschool.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.altschool.id
}

# CREATE ROUTE TABLE ASSOCIATION TO SUBNET
resource "aws_route_table_association" "altschool" {
  subnet_id      = aws_subnet.altschool.id
  route_table_id = aws_route_table.altschool.id
}

# CREATE SECURITY GROUP
resource "aws_security_group" "altschool" {
  name        = "altschool_sg"
  description = "Altschool Terraform mini project security group"
  vpc_id      = aws_vpc.altschool.id

  ingress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# CREATE EC2 KEY PAIR
resource "aws_key_pair" "altschool" {
  key_name   = "altschool"
  public_key = file("~/.ssh/main_terraform.pub")
}