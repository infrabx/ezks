output "groups" {
  description = "A map of groups to their respective details"
  value       = module.groups
}

output "passwords" {
  value       = { for k, u in aws_iam_user_login_profile.this : k => u.encrypted_password }
  description = "Automatically generated (encrypted) passwords for accounts"
}

output "passwords_raw" {
  value       = { for k, u in aws_iam_user_login_profile.this : k => u.password }
  description = "Automatically generated (unencrypted) passwords for accounts"
}
