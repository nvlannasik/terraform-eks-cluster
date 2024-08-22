resource "aws_iam_role" "EKS-PRODUCTION-ANNASIK-NODES" {
  name = "EKS-PRODUCTION-ANNASIK-NODES"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "NODES-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.EKS-PRODUCTION-ANNASIK-NODES.name
}

resource "aws_iam_role_policy_attachment" "NODES-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.EKS-PRODUCTION-ANNASIK-NODES.name
}

resource "aws_iam_role_policy_attachment" "NODES-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.EKS-PRODUCTION-ANNASIK-NODES.name
}

resource "aws_iam_role_policy_attachment" "NODES-EKS-CLUSTER-AUTO-SCALER-POLICY-IAM" {
  role       = aws_iam_role.EKS-PRODUCTION-ANNASIK-NODES.name
  policy_arn = aws_iam_policy.EKS-CLUSTER-AUTO-SCALER-POLICY-IAM.arn
}

resource "aws_eks_node_group" "EKS-PRODUCTION-ANNASIK-ON-DEMAND-NODES" {
  cluster_name    = aws_eks_cluster.EKS-PRODUCTION-ANNASIK.name
  node_group_name = "EKS-PRODUCTION-ANNASIK-ON-DEMAND-NODES"
  node_role_arn   = aws_iam_role.EKS-PRODUCTION-ANNASIK-NODES.arn
  subnet_ids = [
    aws_subnet.Private-Subnet-1.id,
    aws_subnet.Private-Subnet-2.id,
  ]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 1
  }

  ami_type      = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  instance_types = [
    "m5.large",
    "m5a.large",
    "m5zn.large",
    "m5d.large",
    "m5dn.large",
    "m5ad.large"
  ]
  disk_size            = 40
  force_update_version = true

  depends_on = [
    aws_eks_cluster.EKS-PRODUCTION-ANNASIK,
    
  ]

  update_config {
    max_unavailable = 1
  }
  labels = {
    role        = "devops"
    environment = "test"
    node_type   = "on-demand"
  }
  version = "1.27"
  tags = {
    Name        = "EKS-PRODUCTION-ANNASIK-ON-DEMAND-NODES"
    terraform   = true
    Environment = "EKS-PRODUCTION-ANNASIK"
  }
}


resource "aws_eks_node_group" "EKS-PRODUCTION-ANNASIK-ON-SPOT-NODES" {
  cluster_name    = aws_eks_cluster.EKS-PRODUCTION-ANNASIK.name
  node_group_name = "EKS-PRODUCTION-ANNASIK-ON-SPOT-NODES"
  node_role_arn   = aws_iam_role.EKS-PRODUCTION-ANNASIK-NODES.arn
  subnet_ids = [
    aws_subnet.Private-Subnet-1.id,
    aws_subnet.Private-Subnet-2.id,
  ]
  ami_type             = "AL2_x86_64"
  capacity_type        = "SPOT"
  disk_size            = 40
  force_update_version = true
  instance_types       = ["m5.xlarge", "m5a.xlarge", "m5zn.xlarge", "m5d.xlarge", "m5dn.xlarge", "m5ad.xlarge"]

  scaling_config {
    desired_size = 1
    max_size     = 30
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
  labels = {
    role        = "devops"
    environment = "test"
    node_type   = "spot"
  }
  version = "1.27"

  tags = {
    Name        = "EKS-PRODUCTION-ANNASIK-ON-SPOT-NODES"
    terraform   = true
    Environment = "EKS-PRODUCTION-ANNASIK"
  }

  depends_on = [
    aws_iam_role_policy_attachment.NODES-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.NODES-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.NODES-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.NODES-EKS-CLUSTER-AUTO-SCALER-POLICY-IAM

  ]
}
