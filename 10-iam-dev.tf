data "aws_iam_policy_document" "TEST-OIDC-ASSUME-ROLE-POLICY" {
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
      values   = ["system:serviceaccount:default:aws-node"]
    }
  }
}

resource "aws_iam_role" "EKS-PRODUCTION-ANNASIK-NODES-IAM-OIDC" {
  name               = "EKS-PRODUCTION-ANNASIK-NODES-IAM-OIDC"
  assume_role_policy = data.aws_iam_policy_document.TEST-OIDC-ASSUME-ROLE-POLICY.json
}

resource "aws_iam_policy" "EKS-PRODUCTION-ANNASIK-IAM-POLICY-IAM-OIDC" {
  name = "EKS-PRODUCTION-ANNASIK-IAM-POLICY"

  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "EKS-PRODUCTION-ANNASIK-ATTACHMENT" {
  role       = aws_iam_role.EKS-PRODUCTION-ANNASIK-NODES-IAM-OIDC.name
  policy_arn = aws_iam_policy.EKS-PRODUCTION-ANNASIK-IAM-POLICY-IAM-OIDC.arn
}

output "EKS-PRODUCTION-ANNASIK-NODES-ARN" {
  value = aws_iam_role.EKS-PRODUCTION-ANNASIK-NODES-IAM-OIDC.arn
}
