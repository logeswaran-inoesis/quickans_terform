resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
}
# Allocate Elastic IP in AWS

# Create an Elastic IP (EIP) for the static IP
# Elastic IP for static public IP (optional)
# Allocate Elastic IP for NLB
# resource "aws_eip" "nginx_static_ip" {
#   domain = "vpc"
# }

# # Security Group for NGINX Ingress Controller
# resource "aws_security_group" "nginx_sg" {
#   name        = "nginx-sg"
#   description = "Allow inbound traffic for NGINX ingress"
#   vpc_id      = aws_vpc.eks_vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Target Group for NGINX
# resource "aws_lb_target_group" "nginx_tg" {
#   name        = "nginx-tg"
#   port        = 80
#   protocol    = "TCP"
#   vpc_id      = aws_vpc.eks_vpc.id
#   target_type = "ip"
# }

# # Network Load Balancer (NLB)
# resource "aws_lb" "nginx_nlb" {
#   name                              = "nginx-nlb"
#   internal                          = false
#   load_balancer_type                = "network"
#   subnets                           = ["subnet-0b830f6078f5a1bf4", "subnet-040fa70690ccaccb9", "subnet-08ad32ad47622fbc9"]
#   enable_cross_zone_load_balancing = true

#   depends_on = [aws_eip.nginx_static_ip]
# }

# # Listener for the NLB
# resource "aws_lb_listener" "nginx_listener" {
#   load_balancer_arn = aws_lb.nginx_nlb.arn
#   port              = 80
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.nginx_tg.arn
#   }
# }

# # Outputs (⚠️ Move to outputs.tf if you have one)
# # output "vpc_id" {
# #   description = "VPC ID"
# #   value       = aws_vpc.eks_vpc.id
# # }

# output "nlb_dns_name" {
#   value = aws_lb.nginx_nlb.dns_name
# }

# output "static_ip" {
#   value = aws_eip.nginx_static_ip.public_ip
# }
