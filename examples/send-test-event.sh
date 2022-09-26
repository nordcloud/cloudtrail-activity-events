#!/bin/bash

# CREATING EVENT DATA STORE
# aws cloudtrail create-event-data-store \
#     --name klarity-activity-events-2 \
#     --region us-east-1 \
#     --retention-period 30 \
#     --advanced-event-selectors '[{
#         "Name": "Select all external events",
#         "FieldSelectors": [{ 
#             "Field": "eventCategory", "Equals":["ActivityAuditLog"] 
#         }]
#     }]'

# CREATING CHANNEL
# aws cloudtrail create-channel \
#  --region us-east-1 \
#  --name testch \
#  --source "Custom" \
#  --destinations '[{
#         "Type": "EventDataStore", 
#         "Location": "95bcb1bd-787f-4cc2-a7a3-1a8b721123c0"
#     }]'

export UUID="47f43c67-e673-4f29-a637-45c1cd9d77cf"
export CHANNEL_ARN="arn:aws:cloudtrail:us-east-1:313457394549:channel/EXAMPLE-3e94-4edc-833e-EXAMPLE"
export ACCOUNT_ID="EXAMPLE"
export AWS_DEFAULT_REGION="us-east-1"
export ROLE_ARN="arn:aws:iam::EXAMPLE:role/cloud-trail-nordcloud-integration"
export ROLE_EX_ID=$CHANNEL_ARN

export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
$(aws sts assume-role --role-arn $ROLE_ARN \
    --role-session-name kamiltestsession \
    --region us-east-1 \
    --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
    --output text \
    --external-id $ROLE_EX_ID ))

for i in $(seq 1 3)
do
    
    aws cloudtrail-data put-audit-events \
        --channel-arn $CHANNEL_ARN \
        --audit-events '{
            "id": "6df0f951-6f16-4e2b-adb4-ababba1edc53",
            "eventData": "{\"eventTime\":\"2022-09-07T12:00:10Z\",\"version\":\"0.01\",\"UID\":\"'$UUID'\",\"recipientAccountId\":\"'$ACCOUNT_ID'\",\"userIdentity\":{\"type\":\"USER\",\"principalId\":\"name@example.com\"},\"eventSource\":\"com.nordcloudapp.klarity-invalid\", \"eventName\":\"discoveryRule.created\",\"requestParameters\":{\"ruleName\":\"rule name\",\"ruleId\":\"00000000-00000000-00000000-00000001\"}}"
        }'

done
