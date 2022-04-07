###################
# Variables
###################

variable "stage" {
  type        = string
  default     = "prod"
  description = "The name of the deployment environment, e.g. 'staging', 'prod'"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The region being deployed to, e.g. 'us-east-1'"
}