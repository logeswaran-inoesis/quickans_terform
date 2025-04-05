resource "aws_eks_cluster" "quickans_eks" {
  name     = "quickans_eks"
  role_arn = aws_iam_role.eks_master_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_01.id,
      aws_subnet.subnet_02.id,
      length(data.aws_availability_zones.available.names) > 2 ? aws_subnet.subnet_03[0].id : null
    ]
    endpoint_private_access = false
    endpoint_public_access  = true
    security_group_ids      = [aws_security_group.eks_control_plane_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller_policy
  ]
}

resource "aws_eks_node_group" "quickans_nodegroup" {
  cluster_name    = aws_eks_cluster.quickans_eks.name
  node_group_name = "quickansnodegroup"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = [
    aws_subnet.subnet_01.id,
    aws_subnet.subnet_02.id,
    length(data.aws_availability_zones.available.names) > 2 ? aws_subnet.subnet_03[0].id : null
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  ami_type       = "AL2_x86_64"
  instance_types = ["t3.medium"]
  disk_size      = 20

  depends_on = [
    aws_eks_cluster.quickans_eks,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only_policy
  ]
}
