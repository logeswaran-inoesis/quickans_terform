data "tls_certificate" "eks_thumbprint" {
  url = aws_eks_cluster.quickans_eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url             = aws_eks_cluster.quickans_eks.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_thumbprint.certificates[0].sha1_fingerprint]
}
