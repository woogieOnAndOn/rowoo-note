# Common Variables
variable "aws_region" {
  type        = string
}

variable "image_tag" {
  type 			= string
  description 	= "Given image tag for the current deployment."
}

variable "vpc_name" {
  type 	= string
  description = "Name of the containing VPC. Required."
}

variable "public_subnets" {
  type    = list(string)
  default = []
}

variable "service_name" {
  type        = string
  description = "the name of the service."
}