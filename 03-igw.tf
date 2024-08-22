resource "aws_internet_gateway" "IGW-EKS-PRODUCTION-ANNASIK" {
  vpc_id = aws_vpc.VPC-EKS-PRODUCTION-ANNASIK.id

  tags = {
    Name        = "IGW-EKS-PRODUCTION-ANNASIK"
    terraform   = true
    Environment = "EKS-PRODUCTION-ANNASIK"
  }
}
