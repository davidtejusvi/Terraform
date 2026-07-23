# Create IAM user
resource "aws_iam_user" "user" {
  name = var.iam_user_name
  tags = {
    Name = var.iam_user_name
  }
}

# Attach AWS policy : amazonS3FullAccess
resource "aws_iam_user_policy_attachment" "s3_full_access" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# for all users 
resource "aws_iam_user" "users" {
  for_each = toset(var.iam_user_names)
  name     = each.value
  tags = {
    Name = each.value
  }
}

locals {
  managed_policies = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
  ]
}

resource "aws_iam_user_policy_attachment" "attachments" {
  for_each = {
    for pair in flatten([
      for user in var.aws_iam_user.users : [
        for policy in local.managed_policies : {
          key    = "${user}-${basename(policy)}"
          user   = user
          policy = policy
        }
      ]
    ]) : pair.key => pair
  }

  user       = aws_iam_user.users[each.value.user].name
  policy_arn = each.value.policy
}
