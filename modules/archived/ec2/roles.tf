resource "aws_iam_role" "ec2" {
  name = "EC2"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2.name
}

data "aws_iam_policy_document" "ec2_to_s3" {
  statement {
    sid = "ListS3Buckets"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets"
    ]

    resources = [
      "arn:aws:s3:::*",
      "arn:aws:s3:::*/*"
    ]
  }
}

resource "aws_iam_policy" "ec2_to_s3" {
  policy = data.aws_iam_policy_document.ec2_to_s3.json
}

resource "aws_iam_role_policy_attachment" "ec2_to_s3" {
  role      = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.ec2_to_s3.arn
}

# //inline policy
# resource "aws_iam_role_policy" "ec2_to_s3" {
#   name = "ec2_to_s3_policy"
#   policy = data.aws_iam_policy_document.ec2_to_s3.json
#   role   = aws_iam_role.ec2.id
# }