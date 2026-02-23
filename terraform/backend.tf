terraform {
  backend "s3" {
    bucket       = "john-bucket-terraform-state"
    key          = "github.com/demo-website/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}
