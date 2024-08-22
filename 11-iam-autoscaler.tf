data "aws_iam_policy_document" "EKS-AUTO-SCALER-POLICY-DOC-IAM" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.EKS-OPENID.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.EKS-OPENID.arn]
      type        = "Federated"
    }
  }
}


resource "aws_iam_role" "EKS-AUTO-SCALER-ROLE-IAM" {
  name               = "EKS-AUTO-SCALER"
  assume_role_policy = data.aws_iam_policy_document.EKS-AUTO-SCALER-POLICY-DOC-IAM.json
}
resource "aws_iam_policy" "EKS-CLUSTER-AUTO-SCALER-POLICY-IAM" {
  name = "EKS-CLUSTER-AUTO-SCALER-POLICY-IAM"

  policy = jsonencode({
    Statement = [{
      Action = [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "EKS_CLUSTER_AUTO_SCALER-ATTACHMENT-IAM" {
  role       = aws_iam_role.EKS-AUTO-SCALER-ROLE-IAM.name
  policy_arn = aws_iam_policy.EKS-CLUSTER-AUTO-SCALER-POLICY-IAM.arn
}


output "EKS-AUTO-SCALER-ARN" {
  value = aws_iam_role.EKS-AUTO-SCALER-ROLE-IAM.arn

}
