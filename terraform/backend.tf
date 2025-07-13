terraform {
  backend "s3" {
    bucket  = "terraform-state-fadi7ay-testing2"
    key     = "devops-assignment/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}
