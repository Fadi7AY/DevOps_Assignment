data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function_payload.zip"
}


resource "aws_lambda_function" "s3_lambda" {

  function_name = var.lambda_function_name
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role          = aws_iam_role.assign_iam.arn
  handler       = var.lambda_handler # this is so AWS "knows" that file name = lambda_function and Function inside = lambda_handler()
  runtime       = var.lambda_runtime

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.assign_bucket.bucket
      SNS_TOPIC   = aws_sns_topic.assign_topic.arn
    }
    #this passes the values to the lambda func 
  }
}

######### added later , notification when applying code and when uploading files . 
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.assign_bucket.arn
}
# I removed the aws_s3_bucket_notification , that was related to this ( was invoking lambda at any file upload)