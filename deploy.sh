# Get user input params
stackName=$(cat .env | grep STACK_NAME= | cut -d '=' -f2)
profile=$(cat .env | grep PROFILE= | cut -d '=' -f2)
region=$(cat .env | grep REGION= | cut -d '=' -f2)
allowedIp=$(cat .env | grep ALLOWED_IP= | cut -d '=' -f2)
stage=$(cat .env | grep STAGE= | cut -d '=' -f2)
sourceBucketName=activity-logger-source-bucket-$(date +%s)

# Create deployment s3 bucket
echo 'Creating deployment s3 bucket...'
aws s3 mb s3://${sourceBucketName} --profile ${profile}
echo 'Done\n'

# Backend deployment
echo 'Backend deployment...'
cd backend
sam deploy --profile ${profile} --stack-name ${stackName} --region=${region} \
    --parameter-overrides AllowedIp=${allowedIp} Stage=${stage} \
    --s3-bucket=${sourceBucketName} \
    --capabilities CAPABILITY_IAM

# Extract resource values using CF
websiteBucket=$(aws cloudformation describe-stacks --profile ${profile} --stack-name ${stackName} --query "Stacks[0].Outputs[?OutputKey=='FrontendWebSiteBucket'].OutputValue" --output text)
websitepublicUrl=$(aws cloudformation describe-stacks --profile ${profile} --stack-name ${stackName} --query "Stacks[0].Outputs[?OutputKey=='PublicWebSiteURL'].OutputValue" --output text)
apiGatewayUrl=$(aws cloudformation describe-stacks --profile ${profile} --stack-name ${stackName} --query "Stacks[0].Outputs[?OutputKey=='ApiGatewayBaseUrl'].OutputValue" --output text)

echo 'Done\n'

# Frontend deployment
echo 'Frontend deployment...'
cd ../frontend
echo "VUE_APP_API_BASE_URL='$apiGatewayUrl'" > .env
npm install && npm run build
aws s3 cp dist s3://$websiteBucket --recursive --profile personal
echo 'Done\n\n'

echo "See your application at : $websitepublicUrl"
