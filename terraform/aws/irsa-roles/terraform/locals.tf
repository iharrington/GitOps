locals {
  # Base default tags
  default_tags = {
    Product     = var.product_name
    Environment = var.environment
    Owner       = "project-support"
  }
}
