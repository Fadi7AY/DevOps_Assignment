resource "aws_s3_bucket" "assign_bucket" {

    bucket = "assignement-bucket-fadi7-4"
    
    tags = {
      Name = "assignement-bucket-fadi7-4"
    }
}

resource "aws_s3_object" "bucket_objects" {
  for_each = toset(local.sample_files)

  bucket = aws_s3_bucket.assign_bucket.bucket
  key    = each.value
  source = "${path.module}/sample_files/${each.value}"
}

resource "aws_s3_bucket_notification" "s3_trigger" {
  bucket = aws_s3_bucket.assign_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}