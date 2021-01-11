# Get user input params
stackName=$(cat .env | grep STACK_NAME= | cut -d '=' -f2)
profile=$(cat .env | grep PROFILE= | cut -d '=' -f2)
region=$(cat .env | grep REGION= | cut -d '=' -f2)
accountId=$(aws sts get-caller-identity --profile personal --query "Account" --output text)


# Delete frontend deployment bucket
websiteBucket=$(aws cloudformation describe-stacks --profile ${profile} --stack-name ${stackName} --query "Stacks[0].Outputs[?OutputKey=='FrontendWebSiteBucket'].OutputValue" --output text)
aws s3 rb s3://$websiteBucket --force --profile ${profile}

# Delete backend resources
aws cloudformation delete-stack --stack-name ${stackName} --profile ${profile}

# Delete deployment s3 bucket
echo 'Deleting deployment s3 bucket...'
sourceBucketName=activity-logger-source-bucket-$accountId-$region
aws s3 rb s3://${sourceBucketName} --force --profile ${profile}
echo 'Done\n\n'

echo 'Stack deleted successfully'