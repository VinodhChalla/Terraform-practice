resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.project_name
    Terraform = "true"
    Environment = "Dev"
  }
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = var.project_name
    Terraform = "true"
    Environment = "Dev"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id # it will fetch VPC ID created from above code
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${var.project_name}-public-subnet"
    Terraform = "true"
    Environment = "Dev"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-route"
    Terraform = "true"
    Environment = "Dev"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id # it will fetch VPC ID created from above code
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${var.project_name}-private-subnet"
    Terraform = "true"
    Environment = "Dev"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-private-route"
    Terraform = "true"
    Environment = "Dev"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_subnet" "database_subnet" {
  vpc_id     = aws_vpc.main.id # it will fetch VPC ID created from above code
  cidr_block = "10.0.11.0/24"

  tags = {
    Name = "${var.project_name}-database-subnet"
    Terraform = "true"
    Environment = "Dev"
  }
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-database-route"
    Terraform = "true"
    Environment = "Dev"
  }
}

resource "aws_route_table_association" "database" {
  subnet_id      = aws_subnet.database_subnet.id
  route_table_id = aws_route_table.database_route_table.id
}

resource "aws_eip" "NAT" {
    domain = "vpc"

}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.NAT.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "automated-NAT"
  }
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id =  aws_nat_gateway.gw.id
  #depends_on                = [aws_route_table.private]
}

resource "aws_route" "databse" {
  route_table_id            = aws_route_table.database_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id =  aws_nat_gateway.gw.id
  #depends_on                = [aws_route_table.database]
}