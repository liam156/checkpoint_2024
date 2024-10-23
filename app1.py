from flask import Flask, request, jsonify
import boto3
import os
from datetime import datetime

app = Flask(__name__)

# Initialize boto3 clients
sqs = boto3.client('sqs')
ssm = boto3.client('ssm')

# SQS Queue URL and SSM Parameter for token
SQS_QUEUE_URL = os.getenv('SQS_QUEUE_URL')
SSM_TOKEN_PARAMETER = os.getenv('SSM_TOKEN_PARAMETER')

# Fetch the token from AWS SSM Parameter Store or Secrets Manager
def get_stored_token():
    response = ssm.get_parameter(Name=SSM_TOKEN_PARAMETER, WithDecryption=True)
    return response['Parameter']['Value']

# Validate the token and check the payload structure
def validate_request(data, token):
    stored_token = get_stored_token()

    # Check if the provided token is valid
    if token != stored_token:
        return False, "Invalid token"

    # Check if the payload contains the required fields
    required_fields = ["email_subject", "email_sender", "email_timestream", "email_content"]
    for field in required_fields:
        if field not in data:
            return False, f"Missing field: {field}"

    return True, None

@app.route('/send', methods=['POST'])
def send_message():
    content = request.json
    data = content.get("data")
    token = content.get("token")

    # Validate the request
    is_valid, error = validate_request(data, token)
    if not is_valid:
        return jsonify({"error": error}), 400

    # Send the message to SQS
    response = sqs.send_message(
        QueueUrl=SQS_QUEUE_URL,
        MessageBody=str(data),
    )

    return jsonify({"message": "Message sent successfully", "SQSMessageId": response['MessageId']}), 200

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)