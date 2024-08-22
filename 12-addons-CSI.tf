data "aws_iam_policy_document" "EKS-CSI-DRIVER-PRODUCTION-ANNASIK" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      identifiers = [aws_iam_openid_connect_provider.EKS-OPENID.arn]
      type        = "Federated"
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.EKS-OPENID.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
  }
}

resource "aws_iam_role" "EKS-CSI-DRIVER-PRODUCTION-ANNASIK" {
  name               = "EKS-CSI-DRIVER-PRODUCTION-ANNASIK"
  assume_role_policy = data.aws_iam_policy_document.EKS-CSI-DRIVER-PRODUCTION-ANNASIK.json
}

data "aws_iam_policy_document" "EKS-CSI-DRIVER-PRODUCTION-ANNASIK-POLICY" {
  statement {
    actions = [
      "ec2:AttachVolume",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteSnapshot",
      "ec2:DeleteTags",
      "ec2:DeleteVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "EKS-CSI-DRIVER-PRODUCTION-ANNASIK" {
  name   = "EKS-CSI-DRIVER-PRODUCTION-ANNASIK"
  policy = data.aws_iam_policy_document.EKS-CSI-DRIVER-PRODUCTION-ANNASIK-POLICY.json
}

resource "aws_iam_role_policy_attachment" "EKS-CSI-DRIVER-PRODUCTION-ANNASIK" {
  role       = aws_iam_role.EKS-CSI-DRIVER-PRODUCTION-ANNASIK.name
  policy_arn = aws_iam_policy.EKS-CSI-DRIVER-PRODUCTION-ANNASIK.arn
}


resource "aws_eks_addon" "EKS-CSI-DRIVER-PRODUCTION-ANNASIK" {
  cluster_name             = aws_eks_cluster.EKS-PRODUCTION-ANNASIK.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.20.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.EKS-CSI-DRIVER-PRODUCTION-ANNASIK.arn
  depends_on               = [aws_iam_role_policy_attachment.EKS-CSI-DRIVER-PRODUCTION-ANNASIK]
}


output "EKS-CSI-DRIVER-PRODUCTION-ANNASIK" {
  value = aws_iam_role.EKS-CSI-DRIVER-PRODUCTION-ANNASIK.arn
}
