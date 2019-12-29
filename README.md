# check_longtime_stop_instances
Check whether instances keeps stopped status or not.
If are there stopped instances for a long time, notify to slack.

## Prerequisite

### Environment

* Python 3.8
* AWS SAM

### Define Slack webhook URL
1. Put the webhook URL of Slack to SSM Parameter Store.
2. Define SSM Parameter Store key-id to slack_url_ssm_parameter variable in CheckInstanceFunction.

## Build
To build, execute the following command.

```
sam build
```

## Deploy
To deploy, execute the following command.

```
sam deploy --capabilities CAPABILITY_NAMED_IAM
```

