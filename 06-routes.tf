resource "aws_route_table" "PRIVATE-ROUTE-TABLE-01" {
  vpc_id = aws_vpc.VPC-EKS-PRODUCTION-ANNASIK.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NGW-01.id
  }

  tags = {
    Name        = "PRIVATE-ROUTE-TABLE-01"
    terraform   = true
    Environment = "EKS-PRODUCTION-ANNASIK"
  }
}


resource "aws_route_table" "PRIVATE-ROUTE-TABLE-02" {
  vpc_id = aws_vpc.VPC-EKS-PRODUCTION-ANNASIK.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NGW-02.id
  }

  tags = {
    Name        = "PRIVATE-ROUTE-TABLE-02"
    terraform   = true
    Environment = "EKS-PRODUCTION-ANNASIK"
  }
}

resource "aws_route_table" "PUBLIC-ROUTE-TABLE" {
  vpc_id = aws_vpc.VPC-EKS-PRODUCTION-ANNASIK.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW-EKS-PRODUCTION-ANNASIK.id
  }

  tags = {
    Name        = "PUBLIC-ROUTE-TABLE"
    terraform   = true
    Environment = "EKS-PRODUCTION-ANNASIK"
  }

}

resource "aws_route_table_association" "PUBLIC-ROUTE-TABLE-ASSOCIATION" {
  subnet_id      = aws_subnet.Public-Subnet-1.id
  route_table_id = aws_route_table.PUBLIC-ROUTE-TABLE.id
}

resource "aws_route_table_association" "PUBLIC-ROUTE-TABLE-ASSOCIATION-02" {
  subnet_id      = aws_subnet.Public-Subnet-2.id
  route_table_id = aws_route_table.PUBLIC-ROUTE-TABLE.id
}

resource "aws_route_table_association" "PRIVATE-ROUTE-TABLE-ASSOCIATION-01" {
  subnet_id      = aws_subnet.Private-Subnet-1.id
  route_table_id = aws_route_table.PRIVATE-ROUTE-TABLE-01.id
}

resource "aws_route_table_association" "PRIVATE-ROUTE-TABLE-ASSOCIATION-02" {
  subnet_id      = aws_subnet.Private-Subnet-2.id
  route_table_id = aws_route_table.PRIVATE-ROUTE-TABLE-02.id
}
