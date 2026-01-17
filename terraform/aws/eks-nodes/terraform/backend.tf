terraform {
  backend "s3" {
    bucket       = "isaac-terraform-state"
    key          = "eks-nodes/prod/terraform.tfstate"
    region       = "us-west-1"
    use_lockfile = true
    encrypt      = true
  }
}
