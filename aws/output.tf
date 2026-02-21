output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.primary_storage.arn
}

output "bucket_domain_name" {
  description = "The domain name of the bucket"
  value       = aws_s3_bucket.primary_storage.bucket_domain_name
}

# NEW: Security Credentials
output "data_engine_access_key_id" {
  value = aws_iam_access_key.data_engine_keys.id
}

output "data_engine_secret_access_key" {
  value     = aws_iam_access_key.data_engine_keys.secret
  sensitive = true
}