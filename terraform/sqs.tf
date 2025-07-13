resource "aws_sqs_queue" "s3_event_queue" {
  name = "s3-event-queue"
}


resource "aws_s3_bucket_notification" "s3_to_sqs" {
  bucket = aws_s3_bucket.assign_bucket.id

  queue {
    queue_arn = aws_sqs_queue.s3_event_queue.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_sqs_queue.s3_event_queue]
}


resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.s3_event_queue.arn
  function_name    = aws_lambda_function.s3_lambda.arn
  batch_size       = 10
  enabled          = true
}
