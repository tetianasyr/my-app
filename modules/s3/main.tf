resource "aws_s3_bucket" "s3-bucket" {
  bucket = "my-bucket"

  tags = {
    Name = format("My bucket-%s", var.environment)
  }
}