import boto3
import os
import json

s3 = boto3.client('s3')
sns = boto3.client('sns')

def lambda_handler(event, context):
    bucket_name = os.environ['BUCKET_NAME']
    topic_arn = os.environ['SNS_TOPIC']
    
    # list all objects in the bucket
    response = s3.list_objects_v2(Bucket=bucket_name)
    objects = response.get('Contents', [])
    
    file_names = []
    for obj in objects:
        file_names.append(obj['Key'])

    message = f"Lambda executed.\nFound {len(file_names)} file(s) in bucket '{bucket_name}':\n" + "\n".join(file_names)

    # publish to SNS
    sns.publish(
        TopicArn=topic_arn,
        Subject="S3 Bucket Listing",
        Message=message
    
    )
    
    # this is used to invoke
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Execution completed and SNS message sent.',
            'files': file_names
        })
    }