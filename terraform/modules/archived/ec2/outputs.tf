output "public_instance_ids" {
  value = aws_instance.public[*].id
}

output "private_instance_ids" {
  value = aws_instance.private[*].id
}

output "public_security_group_id" {
  value = aws_security_group.public.id
}

# output "private_security_group_id" {
#   value = aws_security_group.private.id
# }

output "iam_instance_profile_ec2" {
  value = aws_iam_instance_profile.ec2_profile.arn
}