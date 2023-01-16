#!/bin/bash

# CREATING EVENT DATA STORE
#
# aws cloudtrail create-event-data-store \
#     --name test \
#     --region us-east-1 \
#     --retention-period 30 \
#     --no-multi-region-enabled \
#     --advanced-event-selectors '[{
#         "Name": "Select all external events",
#         "FieldSelectors": [{ 
#             "Field": "eventCategory", "Equals":["ActivityAuditLog"] 
#         }]
#     }]'

# DATASTORE_ARN is identifier returned by `aws cloudtrail create-event-data-store` command
DATASTORE_ARN="arn:aws:cloudtrail:us-east-1:313457394549:eventdatastore/EXAMPLE-b469-41cb-8c80-EXAMPLE"


# CREATING CHANNEL
#
# aws cloudtrail create-channel \
    # --region us-east-1 \
    # --name testch \
    # --source "Custom" \
    # --destinations "[{
    #     \"Type\": \"EVENT_DATA_STORE\", 
    #     \"Location\": \"${DATASTORE_ARN}\"
    # }]"

# CHANNEL_ARN is identifier returned by `aws cloudtrail create-channel` command
CHANNEL_ARN="arn:aws:cloudtrail:us-east-1:EXAMPLE:channel/EXAMPLE-e43a-40b9-ac71-EXAMPLE"

# EXTERNAL_ID should be provided by third-party application and be customer unique
EXTERNAL_ID="test"
# SOURCE_ACCOUNT_ID is the AWS account ID of third-party application ID used to publish events
SOURCE_ACCOUNT_ID="EXAMPLE"

# PUT RESOURCE BASED POLICY
#
# aws cloudtrail put-resource-policy \
#     --region us-east-1 \
#     --resource-arn "${CHANNEL_ARN}" \
#     --resource-policy "{
#         \"Version\": \"2012-10-17\",
#         \"Statement\": [{
#             \"Sid\": \"ChannelPolicy\",
#             \"Effect\": \"Allow\",
#             \"Principal\": {
#                 \"AWS\": [\"arn:aws:iam::${SOURCE_ACCOUNT_ID}:root\"]
#             },
#             \"Action\": [\"cloudtrail-data:PutAuditEvents\"],
#             \"Resource\": [\"${CHANNEL_ARN}\"],
#             \"Condition\": {
#                 \"StringEquals\": {
#                     \"cloudtrail:ExternalId\": \"${EXTERNAL_ID}\"
#                 }
#             } 
#         }]
#     }"

UUID="47f43c67-e673-4f29-a637-45c1cd9d77cf"
RECIPIENT_ACCOUNT_ID="EXAMPLE"
EVENT_DATA='{
    \"eventTime\":\"2023-01-16T13:00:10Z\",
    \"version\":\"0.01\",
    \"UID\":\"'${UUID}'\",
    \"recipientAccountId\":\"'${RECIPIENT_ACCOUNT_ID}'\",
    \"userIdentity\":{
        \"type\":\"USER\",
        \"principalId\":\"name@example.com\"
    },
    \"eventSource\":\"com.nordcloudapp.klarity\",
    \"eventName\":\"discoveryRule.created\",
    \"requestParameters\":{
        \"ruleName\":\"rule name\",
        \"ruleId\":\"00000000-00000000-00000000-00000001\"
    }
}'

for i in $(seq 1 1)
do
    
    aws cloudtrail-data put-audit-events \
        --channel-arn $CHANNEL_ARN \
        --region "us-east-1" \
        --external-id $EXTERNAL_ID \
        --audit-events "{
            \"id\": \"6df0f951-6f16-4e2b-adb4-ababba1edc53\",
            \"eventData\": \"$(echo $EVENT_DATA)\"
        }"

done
