terraform {
  backend "s3" {
    bucket         = "chi-capstone-sock-shop"
    key            = "terraform/key"
    region         = "us-east-1"
  
  }
}
