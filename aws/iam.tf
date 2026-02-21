# 4. IAM Policy: Defines the "Rulebook" for who can access the bucket
resource "aws_iam_policy" "bucket_access" {
  name        = "DataScienceBucketAccess"
  path        = "/"
  description = "Allows access to the primary data bucket for Iceberg/Analytics"

  # jsonencode converts the Terraform map into a valid AWS JSON string
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Permission to see that the bucket exists and list its contents
        Action = ["s3:ListBucket"]
        Effect = "Allow"
        # Reference: Points specifically to the ARN of the bucket defined above
        Resource = [aws_s3_bucket.primary_storage.arn]
      },
      {
        # Permission to Read (Get) and Write (Put) files
        Action = ["s3:PutObject", "s3:GetObject"]
        Effect = "Allow"
        # The '/*' suffix is a wildcard allowing access to all objects inside the bucket
        Resource = ["${aws_s3_bucket.primary_storage.arn}/*"]
      }
    ]
  })
}
# 5. IAM User: The "Identity" that will act as our Data Engineer
resource "aws_iam_user" "data_engine_user" {
  name = "iceberg-data-engineer"

  tags = {
    Description = "Service account for Iceberg data pipelines"
    Environment = var.env
  }
}

# 6. Policy Attachment: The "Glue" that connects the User to the Rules
resource "aws_iam_user_policy_attachment" "attach_access" {
  user       = aws_iam_user.data_engine_user.name
  policy_arn = aws_iam_policy.bucket_access.arn # Referencing the policy from yesterday
}
# 7. Access Keys: Generates the ID and Secret for the user to log in
resource "aws_iam_access_key" "data_engine_keys" {
  user = aws_iam_user.data_engine_user.name
}
# Create the IAM Role that BigQuery will "assume"
resource "aws_iam_role" "bigquery_omni_role" {
  name = "bigquery-omni-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          # This tells AWS to trust Google's Identity Provider
          Federated = "accounts.google.com"
        }
        Condition = {
          StringEquals = {
            # This is the specific "Subject" (the Google ID) allowed to enter
            "accounts.google.com:sub" = var.google_subject_id # Replace with the actual Google Subject ID of your service account
          }
        }
      }
    ]
  })
}
# This is the piece that was missing from your code!
resource "aws_iam_role_policy_attachment" "omni_s3_read" {
  role       = aws_iam_role.bigquery_omni_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}