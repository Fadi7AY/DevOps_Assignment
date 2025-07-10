resource "aws_sns_topic" "assign_topic" {

    name = "user-notifications-v4"
  
}

resource "aws_sns_topic_subscription" "user_updates" {
  topic_arn = aws_sns_topic.assign_topic.arn
  protocol = "email"
  endpoint  = "fadeyaseen3@gmail.com" #this is for testing 

  lifecycle {  # added this so the subscribtion stays and is not removed
    prevent_destroy = true
  }
}