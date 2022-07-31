variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "cluster_name" {
  default = "eks-cluster-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "associate_public_ip_address" {
  default = true
}

variable "allowed_cidrs" {
  default = ["0.0.0.0/0"]
}

variable "egress_cidrs" {
  default = ["0.0.0.0/0"]
}