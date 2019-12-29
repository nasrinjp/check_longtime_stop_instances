import boto3
import os
from datetime import datetime, timezone, timedelta


def lambda_handler(event, context):
    ec2_client = boto3.client('ec2')
    if event['detail']['state'] == 'stopped':
        ec2_client.create_tags(
            Resources=[event['detail']['instance-id']],
            Tags=[{'Key': os.getenv('tag_name_for_last_stop'),
                   'Value': event['time'].replace('Z', '+00:00')}]
        )
    if event['detail']['state'] == 'running':
        ec2_client.delete_tags(
            Resources=[event['detail']['instance-id']],
            Tags=[{'Key': os.getenv('tag_name_for_last_stop')}]
        )
