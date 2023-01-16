#!/bin/bash

# CREATING EVENT DATA STORE
#
# aws cloudtrail create-event-data-store \
#     --name nordcloud-events-ds \
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
DATASTORE_ARN="arn:aws:cloudtrail:us-east-1:EXAMPLE:eventdatastore/EXAMPLE-b25e-411e-b0d1-EXAMPLE"

aws cloudtrail create-channel \
    --region us-east-1 \
    --name nordcloud-integration \
    --source "NordcloudKlarity" \
    --destinations "[{
        \"Type\": \"EVENT_DATA_STORE\", 
        \"Location\": \"${DATASTORE_ARN}\"
    }]"

CHANNEL_ARN="arn:aws:cloudtrail:us-east-1:EXAMPLE:channel/EXAMPLE-fd81-4185-b9a6-EXAMPLE"
SOURCE_ACCOUNT_ID="855341727128"
EXTERNAL_ID="external_id_received_from_Nordcloud"

# PUT RESOURCE BASED POLICY
#
aws cloudtrail put-resource-policy \
    --region us-east-1 \
    --resource-arn "${CHANNEL_ARN}" \
    --resource-policy "{
        \"Version\": \"2012-10-17\",
        \"Statement\": [{
            \"Sid\": \"ChannelPolicy\",
            \"Effect\": \"Allow\",
            \"Principal\": {
                \"AWS\": [\"arn:aws:iam::${SOURCE_ACCOUNT_ID}:root\"]
            },
            \"Action\": [\"cloudtrail-data:PutAuditEvents\"],
            \"Resource\": [\"${CHANNEL_ARN}\"],
            \"Condition\": {
                \"StringEquals\": {
                    \"cloudtrail:ExternalId\": \"${EXTERNAL_ID}\"
                }
            } 
        }]
    }"
