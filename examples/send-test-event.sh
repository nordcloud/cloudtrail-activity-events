#!/bin/bash

export AWS_REGION=us-east-1
export AWS_DEFAULT_REGION=us-east-1

# CREATING EVENT DATA STORE
# aws cloudtrail create-event-data-store \
#     --name test \
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

export CHANNEL_ARN="arn:aws:cloudtrail:us-east-1:313457394549:channel/6464f5be-705b-4c51-b64c-d46643ff96dc"
export ACCOUNT_ID="313457394549"
export UUID="47f43c67-e673-4f29-a637-45c1cd9d77cf"

aws cloudtrail-data put-audit-events \
    --channel-arn $CHANNEL_ARN \
    --audit-events '{
        "id": "6df0f951-6f16-4e2b-adb4-ababba1edc53",
        "eventData": "{\"eventTime\":\"2022-09-07T12:00:10Z\",\"version\":\"0.01\",\"UID\":\"'$UUID'\",\"recipientAccountId\":\"'$ACCOUNT_ID'\",\"userIdentity\":{\"type\":\"USER\",\"principalId\":\"name@example.com\"},\"eventSource\":\"com.nordcloudapp.com.klarity\", \"eventName\":\"discoveryRule.created\",\"requestParameters\":{\"ruleName\":\"rule name\",\"ruleId\":\"00000000-00000000-00000000-00000001\"}}"
    }'
