variable "user_name" { default = "ubuntu" }
variable "cidr" { default = "10.2.4.0/23" }
variable "instance_type" { default = "m3.2xlarge" }
variable "security_group_name" { default = "terraform" }
variable "ami" { default = "ami-412dcf21" }
# default source_cidr_block is the main subnet
# defined in aws_subnet.main.cidr_block.
variable "source_cidr_block" { default = "10.2.5.128/25" }
variable "region" { default = "us-west-2" }

variable "private_key_file" {
  type    = "string"
  default = "pki/id_rsa"
}

variable "public_key_file" {
  type    = "string"
  default = "pki/id_rsa.pub"
}