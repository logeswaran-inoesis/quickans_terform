variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "192.168.0.0/16"
}

variable "subnet01_cidr" {
  description = "CIDR for Subnet 01"
  default     = "192.168.64.0/18"
}

variable "subnet02_cidr" {
  description = "CIDR for Subnet 02"
  default     = "192.168.128.0/18"
}

variable "subnet03_cidr" {
  description = "CIDR for Subnet 03"
  default     = "192.168.192.0/18"
}
