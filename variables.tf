variable "instanceType" {
  type        = string
  description = "set aws instance type"
  default     = "t2.nano"

}

variable "awsRegion" {
  type        = string
  description = "set aws region"
  default     = "us-east-1"

}
variable "vpc_cidr_bloc" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnets_cidr_block" {
  type        = string
  description = "CIDR block for public in VPC"
  default     = "10.0.0.0/24"

}
variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true 
}

variable "company" {
  type        = string
  description = "comapgny name for ressource tagging"
  default     = "f2i" 
}
variable "project" {
  type        = string
  description = "projet name for ressource tagging"
  
}
variable "billing_code" {
  type        = string
  description = "Billing  code for ressources tagging"
  default     = "051826712228" 
}


