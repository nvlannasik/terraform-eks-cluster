provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# provider "helm" {
#   kubernetes {
#     host                   = aws_eks_cluster.EKS-PRODUCTION-ANNASIK.endpoint
#     cluster_ca_certificate = base64decode(aws_eks_cluster.EKS-PRODUCTION-ANNASIK.certificate_authority.0.data)
#     token                  = data.aws_eks_cluster_auth.EKS-PRODUCTION-ANNASIK.token
#     load_config_file       = false
#   }
# }


# terraform {
#   backend "s3" {
#     bucket  = "terraform-remote-state-eks-PRODUCTION-ANNASIK"
#     key     = "terraform.tfstate"
#     region  = "ap-southeast-1"
#     encrypt = true
#   }
# }
