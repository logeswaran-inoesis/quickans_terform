provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "eks_cluster" {
  name = aws_eks_cluster.quickans_eks.name
}

data "aws_eks_cluster_auth" "eks_auth" {
  name = aws_eks_cluster.quickans_eks.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_auth.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks_auth.token
  }
}
