variable "bucket_name" {
  type        = string
  default     = "assignement-bucket-fadi7-4"
}

variable "sns_topic_name" {
  type        = string
  default     = "user-notifications-v4"
}

variable "sns_email_endpoint" {
  type        = string
  default     = "fadeyaseen3@gmail.com"
}

variable "lambda_function_name" {
  type        = string
  default     = "list-s3-files-4"
}

variable "lambda_runtime" {
  type        = string
  default     = "python3.12"
}

variable "lambda_handler" {
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "iam_role_name" {
  type        = string
  default     = "LambdaAssignmentRoleV4"
}
