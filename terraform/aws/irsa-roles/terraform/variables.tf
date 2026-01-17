variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-1"
}

variable "product_name" {
  description = "Product name for Backstage"
  type        = string
  default     = "IRSA"
}

variable "environment" {
  description = "Environment for Backstage"
  type        = string
  default     = "prod"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "isaac-eks-cluster"
}

variable "terraform_client_id" {
  description = "Client ID for Terraform OIDC provider"
  type        = string
}

variable "eks_client_id" {
  description = "Client ID for EKS OIDC provider"
  type        = string
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID for OIDC provider"
  type        = string
}
