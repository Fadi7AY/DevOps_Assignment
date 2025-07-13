resource "aws_sns_topic" "assign_topic" {

    name = var.sns_topic_name
  
}

resource "aws_sns_topic_subscription" "user_updates" {
  topic_arn = aws_sns_topic.assign_topic.arn
  protocol = "email"
  endpoint = var.sns_email_endpoint #this is for testing 

  lifecycle {  # added this so the subscribtion stays and is not removed
    prevent_destroy = true
  }
}