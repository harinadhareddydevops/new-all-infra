resource "aws_s3_bucket" "tfstatefile" {
  bucket = "aws-artifactory-devops-practice"

  tags = {
    Name        = "aws-artifactory-devops-practice"
    Environment = "Dev"
  }
}