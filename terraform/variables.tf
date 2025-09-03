variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "public_key_path" {
  description = "ABSOLUTE path to your PUBLIC ssh key (e.g., /Users/you/.ssh/tc3.pub)"
  type        = string
}

variable "allow_ssh_cidr" {
  description = "CIDR allowed to SSH (22)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "allow_http_cidr" {
  description = "CIDR allowed to HTTP (80)"
  type        = string
  default     = "0.0.0.0/0"
}
