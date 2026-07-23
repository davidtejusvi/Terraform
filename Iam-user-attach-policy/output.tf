output "iam_user_name" {
  value = aws_iam_user.user.name
}

output "iam_user_arn" {
  value = aws_iam_user.user.arn
}

output "iam_user_names" {
  value = [for users in aws_aws_iam_user.users : user.name]
}

output "iam_users_arn" {
  value = [for users in aws_iam_user.users : user.arn]

}
