variable "bucket_name" {
  description = "initial storage of the S3 bucket"
  type        = string
  default     = "fundamental-ananlysis-dax-076360446836-eu-central-1"
}

variable "env" {
  type    = string
  default = "Prod"
}