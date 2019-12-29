import os
import logging
import boto3
from datetime import datetime, timezone, timedelta
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError
from base64 import b64decode
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    ec2_client = boto3.client('ec2')
    instance_list = get_instance_list(ec2_client)
    long_stop_instance_list = []
    for instance in instance_list:
        last_stop_time = get_ec2_last_stop_time(instance)
        if last_stop_time != None:
            last_stop_date = datetime.fromisoformat(
                last_stop_time).astimezone(timezone(timedelta(hours=+9))).date()
            today = datetime.now(timezone(timedelta(hours=+9))).date()
            days_ago = (today - last_stop_date).days
            if days_ago >= int(os.getenv('stop_period', '0')):
                logger.info(
                    f'{instance["InstanceId"]} has been stopped for {days_ago} days.')
                long_stop_instance_list.append(instance['InstanceId'])
    if len(long_stop_instance_list) > 0:
        tag_list = ec2_client.describe_tags(
            Filters=[
                {'Name': 'resource-id', 'Values': long_stop_instance_list}
            ])['Tags']
        long_stop_instances_list = [f"Nameタグ={tag['Value']} ({tag['ResourceId']})"
                                    for tag in tag_list
                                    if tag['Key'] == 'Name']
        long_stop_instances = '\n'.join(long_stop_instances_list)
        notify_slack(generate_slack_message(
            f'{os.getenv("stop_period", "0")}日以上停止しているEC2インスタンス', long_stop_instances, 'warning'))


def get_instance_list(ec2_client):
    instance_list = [instance
                     for reservations in ec2_client.describe_instances()['Reservations']
                     for instance in reservations['Instances']]
    return instance_list


def get_ec2_last_stop_time(instance):
    for tag in instance['Tags']:
        if tag['Key'] == os.getenv('tag_name_for_last_stop'):
            return tag['Value']


def generate_slack_message(title, bodystr, color):
    attachments_json = [
        {
            "color": color,
            "title": title,
            "fields": [
                {
                    "value": bodystr,
                    "short": False
                }
            ]
        }
    ]
    slack_message = {
        'attachments': attachments_json
    }
    return slack_message


def get_slack_url(slack_url_ssm_parameter):
    return boto3.client('ssm').get_parameter(Name=slack_url_ssm_parameter, WithDecryption=True)['Parameter']['Value']


def notify_slack(slack_message):
    slack_url = get_slack_url(os.getenv('slack_url_ssm_parameter'))
    req = Request(slack_url, json.dumps(slack_message).encode('utf-8'))
    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted")
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)
