import boto3
import os
import time
import json

# Initialize boto3 clients
sqs = boto3.client('sqs')
s3 = boto3.client('s3')

# SQS Queue URL and S3 bucket
SQS_QUEUE_URL = os.getenv('SQS_QUEUE_URL')
S3_BUCKET_NAME = os.getenv('S3_BUCKET_NAME')

def process_message(message):
    # Here you would process the message as necessary
    # For this example, we're just uploading it to S3 as a JSON file
    filename = f"{int(time.time())}.json"
    s3.put_object(Bucket=S3_BUCKET_NAME, Key=filename, Body=json.dumps(message))
    print(f"Uploaded {filename} to S3 bucket {S3_BUCKET_NAME}")

def poll_sqs():
    while True:
        print("Polling SQS for messages...")
        response = sqs.receive_message(
            QueueUrl=SQS_QUEUE_URL,
            MaxNumberOfMessages=1,
            WaitTimeSeconds=20  # Long polling
        )

        messages = response.get('Messages', [])
        for message in messages:
            process_message(json.loads(message['Body']))
            
            # Delete the message from SQS
            sqs.delete_message(
                QueueUrl=SQS_QUEUE_URL,
                ReceiptHandle=message['ReceiptHandle']
            )
        time.sleep(10)  # Poll every 10 seconds

if __name__ == "__main__":
    poll_sqs()