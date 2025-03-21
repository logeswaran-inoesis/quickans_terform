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

output "eks_worker_role_name" {
  description = "Name of the EKS Worker Node IAM Role"
  value       = aws_iam_role.eks_node_role.name
}

output "eks_worker_role_arn" {
  description = "ARN of the EKS Worker Node IAM Role"
  value       = aws_iam_role.eks_node_role.arn
}
