resource "aws_iam_role" "ROLE-EKS-CLUSTER-PRODUCTION-ANNASIK" {
  name = "ROLE-EKS-CLUSTER-PRODUCTION-ANNASIK"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_eks_cluster" "EKS-PRODUCTION-ANNASIK" {
  name     = "EKS-PRODUCTION-ANNASIK"
  role_arn = aws_iam_role.ROLE-EKS-CLUSTER-PRODUCTION-ANNASIK.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.Private-Subnet-1.id,
      aws_subnet.Private-Subnet-2.id,
      aws_subnet.Public-Subnet-1.id,
      aws_subnet.Public-Subnet-2.id,
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  role       = aws_iam_role.ROLE-EKS-CLUSTER-PRODUCTION-ANNASIK.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
