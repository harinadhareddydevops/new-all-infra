# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "4.28.0"
#     }
#   }
# }

# provider "aws" {
#   region = var.aws_region
#   avalibility_zone =[us-east-1a,us-east-1b,us-east,us-east-1c]
# }
provider "aws" {
  # Configuration options
  region = var.region
}