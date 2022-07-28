variable "region" {
    default = "us-east-1"
}


variable "vpc_cidr" {
    default = "10.0.0.0/16"
}


variable "availability_zones" {
    default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}


variable "public_subnet_cidrs" {
    default = [
        "10.0.1.0/24",
        "10.0.2.0/24"
    ]
}

variable "private_subnet_cidrs" {
    default = [
        "10.0.11.0/24",
        "10.0.22.0/24"
    ]
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