terraform {
  backend "s3" {
    bucket       = "isaac-terraform-state"
    key          = "irsa/prod/terraform.tfstate"
    region       = "us-west-1"
    use_lockfile = true
    encrypt      = true
  }
}
