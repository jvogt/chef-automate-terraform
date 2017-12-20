variable "amis" {
  description = "AMIs by region"
  default = {
    us-west-2 = "ami-25cf1c5d" # ubuntu 14.04 LTS
  }
}

variable "aws_key_name" {}
variable "aws_key_path" {}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default = "10.0.1.0/24"
}

variable "aws_username" {
  description = "Used for tagging"
}