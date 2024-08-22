resource "aws_vpc" "VPC-EKS-PRODUCTION-ANNASIK" {
  cidr_block = "172.10.0.0/22"

  tags = {
    Name        = "VPC-EKS-PRODUCTION-ANNASIK"
    terraform   = true
    Environment = "EKS-PRODUCTION-ANNASIK"
  }
}
