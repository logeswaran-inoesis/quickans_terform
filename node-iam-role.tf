resource "aws_iam_role" "eks_node_role" {
  name = "eksworkerrole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_read_only_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
resource "aws_iam_policy" "detach_attach_volume_policy" {
  name        = "EKSDetachAttachVolumePolicy"
  description = "Allows attaching and detaching volumes for EKS worker nodes"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DetachVolume",
          "ec2:DescribeInstances",
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "detach_attach_volume_policy_attachment" {
  name       = "eks-detach-attach-volume-policy-attachment"
  roles      = [aws_iam_role.eks_node_role.name]
  policy_arn = aws_iam_policy.detach_attach_volume_policy.arn
}
