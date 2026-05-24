variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "public_subnet_1a_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_1b_cidr_block" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet_1a_cidr_block" {
  type    = string
  default = "10.0.3.0/24"
}

variable "private_subnet_1b_cidr_block" {
  type    = string
  default = "10.0.4.0/24"
}

variable "ssh_allowed_cidr" {
  type        = string
  description = "CIDR block allowed to SSH into public instances. Replace with your public IP /32."
  default     = "0.0.0.0/0"
}
