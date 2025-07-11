resource "aws_lambda_function" "s3_lambda" {

  function_name = "list-s3-files-4"
  filename      = "${path.module}/../lambda/lambda_function_payload.zip"
  role          = aws_iam_role.assign_iam.arn
  handler       = "lambda_function.lambda_handler" # this is so AWS "knows" that file name = lambda_function and Function inside = lambda_handler()
  runtime       = "python3.12"

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
