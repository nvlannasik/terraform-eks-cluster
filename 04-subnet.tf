resource "aws_subnet" "Public-Subnet-1" {
  vpc_id                  = aws_vpc.VPC-EKS-PRODUCTION-ANNASIK.id
  cidr_block              = "172.10.0.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                              = "Public-Subnet-1"
    "kubernetes.io/role/elb"            = 1
    "kubernetes.io/cluster/EKS-PRODUCTION-ANNASIK" = "owned"
  }
}

resource "aws_subnet" "Public-Subnet-2" {
  vpc_id                  = aws_vpc.VPC-EKS-PRODUCTION-ANNASIK.id
  cidr_block              = "172.10.1.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                              = "Public-Subnet-2"
    "kubernetes.io/role/elb"            = 1
    "kubernetes.io/cluster/EKS-PRODUCTION-ANNASIK" = "owned"
  }
}
resource "aws_subnet" "Private-Subnet-1" {
  vpc_id                  = aws_vpc.VPC-EKS-PRODUCTION-ANNASIK.id
  cidr_block              = "172.10.2.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false

  tags = {
    "Name"                              = "Private-Subnet-1"
    "kubernetes.io/role/internal-elb"   = 1
    "kubernetes.io/cluster/EKS-PRODUCTION-ANNASIK" = "owned"
  }
}

resource "aws_subnet" "Private-Subnet-2" {
  vpc_id                  = aws_vpc.VPC-EKS-PRODUCTION-ANNASIK.id
  cidr_block              = "172.10.3.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = false

  tags = {
    "Name"                              = "Private-Subnet-2"
    "kubernetes.io/role/internal-elb"   = 1
    "kubernetes.io/cluster/EKS-PRODUCTION-ANNASIK" = "owned"
  }
}
