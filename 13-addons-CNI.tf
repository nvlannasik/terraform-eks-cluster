data "aws_iam_policy_document" "EKS-CNI-PRODUCTION-ANNASIK-POLICY-DOC-IAM" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.EKS-OPENID.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.EKS-OPENID.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "EKS-CNI-PRODUCTION-ANNASIK" {
  name               = "EKS-CNI-PRODUCTION-ANNASIK"
  assume_role_policy = data.aws_iam_policy_document.EKS-CNI-PRODUCTION-ANNASIK-POLICY-DOC-IAM.json
}

resource "aws_iam_role_policy_attachment" "EKS-CNI-PRODUCTION-ANNASIK" {
  role       = aws_iam_role.EKS-CNI-PRODUCTION-ANNASIK.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


resource "aws_eks_addon" "EKS-CNI-PRODUCTION-ANNASIK" {
  cluster_name                = aws_eks_cluster.EKS-PRODUCTION-ANNASIK.name
  addon_name                  = "vpc-cni"
  addon_version               = "v1.13.2-eksbuild.1"
  service_account_role_arn    = aws_iam_role.EKS-CNI-PRODUCTION-ANNASIK.arn
  depends_on                  = [aws_iam_role_policy_attachment.EKS-CNI-PRODUCTION-ANNASIK]
  resolve_conflicts_on_create = "OVERWRITE"
}


resource "aws_eks_addon" "EKS-CORE-DNS" {
  cluster_name                = aws_eks_cluster.EKS-PRODUCTION-ANNASIK.name
  addon_name                  = "coredns"
  addon_version               = "v1.10.1-eksbuild.1"
  service_account_role_arn    = aws_iam_role.EKS-CNI-PRODUCTION-ANNASIK.arn
  depends_on                  = [aws_iam_role_policy_attachment.EKS-CNI-PRODUCTION-ANNASIK]
  resolve_conflicts_on_update = "OVERWRITE"
}
