import boto3
import json

# Initialize the Lambda client
lambda_client = boto3.client(
    'lambda',
    region_name='us-west-2'  # Replace with your Lambda's region
)

# Function name from the Terraform configuration
function_name = "example-lambda"

# Payload to send to the Lambda function
payload = {
    "key1": "value1",  # Replace with your actual input data
    "key2": "value2",
}

try:
    # Invoke the Lambda function
    response = lambda_client.invoke(
        FunctionName=function_name,
        InvocationType='RequestResponse',  # Use 'Event' for asynchronous invocation
        Payload=json.dumps(payload)
    )

    # Read and decode the response
    response_payload = response['Payload'].read().decode('utf-8')
    print("Lambda Response:", response_payload)

except Exception as e:
    print("Error invoking Lambda function:", str(e))
