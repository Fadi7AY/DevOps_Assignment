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
            "${aws_s3_bucket.assign_bucket.arn}",
            "${aws_s3_bucket.assign_bucket.arn}/*"
        ]
      },

      {
        "Effect":"Allow",
        "Action":"sns:Publish",
        "Resource": "${aws_sns_topic.assign_topic.arn}"
      },
      {
        Effect = "Allow",
        Action = "sqs:ReceiveMessage",
        Resource = aws_sqs_queue.s3_event_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test_attach" {
  role       = aws_iam_role.assign_iam.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}