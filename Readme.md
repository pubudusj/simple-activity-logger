# Simple Action Logger

This project contains the souce code for both backend and frontend for a simple activity logger create using AWS Serverless.

You may read about this more at this blog post: [Dev.to](https://dev.to/pubudusj/how-i-created-a-simple-activity-logger-with-aws-serverless-to-record-nuisance-activities-of-my-neighbor-3g2n)

## Prerequisites

* Need to have AWS SAM CLI and npm installed

## How to install

1. Duplicate the .env.example file as .env

2. You need to set the parameters in this .env with your desired values.
STACK_NAME - name of the stack
PROFILE - AWS CLI profile. Keep as default if you use the default profile.
REGION - AWS region which you are going to create the stack.
STAGE - AWS API gateway stage
ALLOWED_IP - This is the IP you need to whitelist to access the project.

3. Once above env variables are set, please run:
```
chmod 755 deploy.sh && ./deploy.sh
```
This will deploy the backend, build the frontend and upload the contents to a s3 web hosting bucket.
Final public url of the system will be output.


## Cleanup
To clean up the project removing all the resources created in AWS, run:
```
chmod 755 tear-down.sh && ./tear-down.sh
```
