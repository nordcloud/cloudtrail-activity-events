#!/bin/bash

# CREATING EVENT DATA STORE
# aws cloudtrail create-event-data-store \
#     --name test \
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
#         "Location": "EXAMPLE-787f-4cc2-a7a3-EXAMPLE"
#     }]'

export CHANNEL_ARN="arn:aws:cloudtrail:us-east-1:EXAMPLE:channel/EXAMPLE-fb04-4ffa-8170-EXAMPLE"
export ACCOUNT_ID="EXAMPLE"
export UUID="47f43c67-e673-4f29-a637-45c1cd9d77cf"

aws cloudtrail-data put-audit-events \
    --channel-arn $CHANNEL_ARN \
    --audit-events '{
        "id": "6df0f951-6f16-4e2b-adb4-ababba1edc53",
        "eventData": "{\"eventTime\":\"2022-09-07T12:00:10Z\",\"version\":\"0.01\",\"UID\":\"'$UUID'\",\"recipientAccountId\":\"'$ACCOUNT_ID'\",\"userIdentity\":{\"type\":\"USER\",\"principalId\":\"name@example.com\"},\"eventSource\":\"com.nordcloudapp.autobackups\", \"eventName\":\"discoveryRule.created\",\"requestParameters\":{\"ruleName\":\"rule name\",\"ruleId\":\"00000000-00000000-00000000-00000001\"}}"
    }'
