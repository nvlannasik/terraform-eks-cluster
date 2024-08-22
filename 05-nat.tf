resource "aws_eip" "NAT-01" {
  domain = "vpc"

  tags = {
    Name        = "NAT-01-EKS-PRODUCTION-ANNASIK"
    terraform   = true
    Environment = "EKS-PRODUCTION-ANNASIK"
  }
}

resource "aws_eip" "NAT-02" {
  domain = "vpc"

  tags = {
    Name        = "NAT-02-EKS-PRODUCTION-ANNASIK"
    terraform   = true
    Environment = "EKS-PRODUCTION-ANNASIK"
  }
}

resource "aws_nat_gateway" "NGW-01" {
  allocation_id = aws_eip.NAT-01.id
  subnet_id     = aws_subnet.Public-Subnet-1.id

  tags = {
    Name        = "NGW-01-EKS-PRODUCTION-ANNASIK"
    terraform   = true
    Environment = "EKS-PRODUCTION-ANNASIK"
  }

  depends_on = [aws_internet_gateway.IGW-EKS-PRODUCTION-ANNASIK]
}


resource "aws_nat_gateway" "NGW-02" {
  allocation_id = aws_eip.NAT-02.id
  subnet_id     = aws_subnet.Public-Subnet-2.id

  tags = {
    Name        = "NGW-02-EKS-PRODUCTION-ANNASIK"
    terraform   = true
    Environment = "EKS-PRODUCTION-ANNASIK"
  }

  depends_on = [aws_internet_gateway.IGW-EKS-PRODUCTION-ANNASIK]
}
