import json
import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Retrieve bucket and object information from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    # Log the details to CloudWatch Logs
    print(f"Object '{key}' uploaded to bucket '{bucket}'")
    
    # You can add your custom logic here to process the uploaded object
    # For example, you can read, transform, or move the object to another location.
    
    return {
        'statusCode': 200,
        'body': json.dumps('Lambda function executed successfully!')
    }
