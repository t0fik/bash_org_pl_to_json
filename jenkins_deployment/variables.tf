variable "user_name" {
  type = string
  default = "ec2-user"
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
}

variable "private_key" {
  type = string
  description = "Path to ssh private key"
}