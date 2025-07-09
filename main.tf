provider "aws" {

    region = "eu-central-1"
  
}

resource "aws_s3_bucket" "assign_bucket" {

    bucket = "assignement-bucket-fadi7-4"
    
    tags = {
      Name = "assignement-bucket-fadi7-4"
    }
}

# resource "aws_s3_bucket" "terraform_state_file_bucket" { # this is used so both the github actions and terraform share same state file , so it doesnt matter if
#                                                          # I do terrafrom apply or run the actions manually !

#     bucket = "terraform-state-file-fadi7"
    
#     tags = {
#       Name = "terraform-state-file-fadi7"
#     }

#   #   lifecycle {  
#   #   prevent_destroy = true
#   # }
# }

locals {
  sample_files = fileset("${path.module}/sample_files", "*")
}

resource "aws_s3_object" "bucket_objects" {
  for_each = toset(local.sample_files)

  bucket = aws_s3_bucket.assign_bucket.bucket
  key    = each.value
  source = "${path.module}/sample_files/${each.value}"
}

# resource "aws_s3_object" "terraform_state" {

#     bucket = aws_s3_bucket.terraform_state_file_bucket.bucket
#     key = "state_file"
#     source = "/home/fadi7ay/DevOps_Assignment/terraform.tfstate"

#   }

resource "aws_iam_role" "assign_iam" {

#AWS_DOCS
    assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "LambdaAssignmentRoleV4"
  }
}

resource "aws_iam_policy" "lambda_s3_policy" {

  #Terraform + AWS DOCS

  name = "lambda_s3_policy_v4"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:Get*",
          "s3:List*",
          "s3:Describe*",
          "s3-object-lambda:Get*",
          "s3-object-lambda:List*"
        ],

        #For least-privilege access only to my assignement bucket!!
        "Resource": [
            "arn:aws:s3:::assignement-bucket-fadi7-4",
            "arn:aws:s3:::assignement-bucket-fadi7-4/*"
        ]
      },

      {
        "Effect":"Allow",
        "Action":"sns:Publish",
        "Resource": "${aws_sns_topic.assign_topic.arn}"
      }
    ]
  })
}

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

# resource "aws_sns_topic_subscription" "user_updates_2" {    #THIS WAS USED TO TEST THE prevent_destroy
#   topic_arn = aws_sns_topic.assign_topic.arn
#   protocol = "email"
#   endpoint  = "fadeyaseen6@gmail.com" #this is for testing 

#   lifecycle {  # added this so the subscribtion stays and is not removed
#     prevent_destroy = true
#   }
# }

resource "aws_iam_role_policy_attachment" "test_attach" {
  role       = aws_iam_role.assign_iam.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

resource "aws_lambda_function" "s3_lambda" {

  function_name = "list-s3-files-4"
  filename      = "lambda_function_payload.zip"
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

resource "aws_s3_bucket_notification" "s3_trigger" {
  bucket = aws_s3_bucket.assign_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

# resource "aws_s3_bucket_object" "name" {
  
# }
