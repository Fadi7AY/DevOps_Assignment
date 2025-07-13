terraform {
  backend "s3" {
    bucket  = "terraform-state-fadi7ay"
    key     = "devops-assignment/terraform-state-loss-test.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}
