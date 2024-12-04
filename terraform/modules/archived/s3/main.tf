resource "aws_s3_bucket" "s3-bucket" {
  bucket = "my-bucketapp-tf-test-media"

  tags = {
    Name = format("My bucket-%s", var.environment)
  }
}