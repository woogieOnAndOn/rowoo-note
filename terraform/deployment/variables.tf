# Common Variables
variable "aws_region" {
  type        = string
}

variable "latest_image_tag" {
  type 			= string
  description 	= "Given image tag for the current deployment."
}

variable "service_name" {
  type        = string
  description = "the name of the service."
}