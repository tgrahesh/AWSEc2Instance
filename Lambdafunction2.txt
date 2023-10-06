import json
import boto3

ses = boto3.client('ses')
def lambda_handler(event, context):
    # Extract the form data from the event
    form_data = json.loads(event['body'])
    # Process the form data
    print(form_data)
    form_data_dict = dict(item.split("=") for item in form_data.split("&"))
    specific_value = form_data_dict.get('q7_message')
    
# Define email parameters
    sender_email = 'tgrahesh@gmail.com'  # SES verified sender email
    recipient_email = 'tgrahesh@gmail.com'  # The recipient's email address
    subject = 'specific_value'
    message = f'Website input received: {json.dumps(form_data, indent=2)}'

    # Send the email
    response = ses.send_email(
        Source=sender_email,
        Destination={'ToAddresses': tgrahesh@gmail.com},
        Message={
            'Subject': {'Data': subject},
            'Body': {'Text': {'Data': message}}
        }
    )
    return {
        'statusCode': 200,
        'body': json.dumps('Form data received and processed successfully. Notification sent!')
    }