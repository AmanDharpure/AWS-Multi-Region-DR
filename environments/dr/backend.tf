terraform {
  backend "s3" {
    bucket       = "aman-multi-region-dr-terraform-state-973008109674"
    key          = "dr/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}