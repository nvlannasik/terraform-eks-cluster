data "tls_certificate" "EKS-TLS" {
  url = aws_eks_cluster.EKS-PRODUCTION-ANNASIK.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "EKS-OPENID" {
  url             = aws_eks_cluster.EKS-PRODUCTION-ANNASIK.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.EKS-TLS.certificates[0].sha1_fingerprint]
}
