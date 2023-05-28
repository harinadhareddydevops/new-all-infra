/* terraform {
  backend "s3" {
    bucket         = "devops-remote-tfstatefile"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "remote-tf-state-file"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "remote-tf-state-file"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
} */