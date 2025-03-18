output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.eks_vpc.id
}

output "subnet_ids" {
  description = "Subnet IDs"
  value = [
    aws_subnet.subnet_01.id,
    aws_subnet.subnet_02.id,
    aws_subnet.subnet_03[*].id
  ]
}

output "security_group_id" {
  description = "Control plane security group"
  value       = aws_security_group.eks_control_plane_sg.id
}

output "eks_master_role_arn" {
  description = "IAM Role ARN for EKS Master Role"
  value       = aws_iam_role.eks_master_role.arn
}
