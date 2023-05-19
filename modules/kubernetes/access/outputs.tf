output "policies" {
  description = "The configured group policies for access to the cluster"
  value       = aws_iam_policy.this
}
