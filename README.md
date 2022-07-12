# Klarity Cloud Trail Open Audit Events

This repository contains all important information and examples related to the Nordcloud Klarity Suite Cloud Trail integration.

***disclaimer: This document is a draft only. Cloud Trail Open Audit Events are not yet fully integrated with the Nordcloud Klarity Suite applications.***

- [Klarity Cloud Trail Open Audit Events](#klarity-cloud-trail-open-audit-events)
  - [AWS Cloud Trail Events](#aws-cloud-trail-events)
    - [Basic information](#basic-information)
    - [Event schema](#event-schema)
    - [Prerequisites](#prerequisites)
  - [Klarity Suite integration](#klarity-suite-integration)
    - [Description](#description)
    - [Enabling integration](#enabling-integration)
    - [Event Sources](#event-sources)
    - [Event types](#event-types)
  - [Architecture](#architecture)
  - [Examples](#examples)
  - [Support](#support)

## AWS Cloud Trail Events

### Basic information

Open audit events let you use CloudTrail to log and store user activity data from any source in your
hybrid environments, such as in-house or SaaS applications hosted on-premises or in the cloud,
virtual machines, or containers. You can store, access, analyze, troubleshoot and take action on
this data without maintaining multiple log aggregators and reporting tools.

Once you ingest event data from third party application or `PutAuditEvents` API, you can create event data
stores in CloudTrail Lake, and use CloudTrail Lake to search, query, and analyze the data that is logged
from your applications.

For more information please refer to [AWS documentation](https://docs.aws.amazon.com/).

### Event schema

```json
{
  "eventVersion": String,
  "eventCategory": String,
  "eventType": String,
  "eventID": String,
  "eventTime": String,
  "awsRegion": String,
  "recipientAccountId": String,
  "addendum": {
    "reason": String,
    "updatedFields": String,
    "originalUID": String,
    "originalEventID": String
  },
  "metadata" : {
    "ingestionTime": String,
    "ingestionChannelARN": String
  },
  "eventData": {
    "version": String,
    "userIdentity": {
      "type": String,
      "principalId": String,
      "details": {
        JSON
      }
    },
    "userAgent": String,
    "eventSource": String,
    "eventName": String,
    "eventTime": String,
    "UID": String,
    "requestParameters": {
      JSON
    },
    "responseElements": {
      JSON
    },
    "errorCode": String,
    "errorMessage": String,
    "sourceIPAddress": String,
    "recipientAccountId": String,
    "additionalEventData": {
      JSON
    }
  }
}
```

For more information please refer to [AWS documentation](https://docs.aws.amazon.com/).

### Prerequisites

In order receive Cloud Trail Events from third party application like Nordcloud Klarity Site following actions are required:

1. Create IAM role that allows third party application to use Cloud Trail API. IAM policy can be found in [policy.json](./policy.json) file.
2. Create Event Data Store in Cloud Trail Lake to store incoming events. You can do that by running following API call:

    ```bash
    aws cloudtrail create-event-data-store \
      --name my-event-data-store \
      --retention-period 90
    ```

3. Create an ingestion channel to ingest events from third party application. You can do that by running following API call:

    ```bash
    aws cloudtrail create-ingestion-channel \
      --region us-east-1 \
      --name my-customer-ingestion-channel \
      --source-name $partnerSourceName \
      --event-data-stores ["EXAMPLEg922-5n2l-3vz1-apqw8EXAMPLE"]
    ```

For more details regaring Cloud Trail setup please refer to [AWS documentation](https://docs.aws.amazon.com/).

## Klarity Suite integration

### Description 2

Nordcloud Klarity Suite that combines multiple integration is integrated with Cloud Trail Lake to store and monitor customer tenant activity. You can enable this integration to receive logs on activities occurred in your application tenant. Events published by the Nordcloud Klarity Suite can be related to the actions performed by applications on customer cloud environments or any other tenant activity.

Ingested events are stored in the customer AWS account in Cloud Trail Lake Data Store. Customer can run queries or any other processing on this data.

Example use cases for using Cloud Trail Events:

- Monitor user activity on application tenant.
- Store and analyze tenant configuration changes.
- Monitor actions executed by SaaS application on customer AWS accounts or any other environment used by the application.
- Ensure company compliance by having direct access to all events produced by third party application.

***Nordcloud Klarity Suite is an AWS partner in Cloud Trail Open Events integration. It makes it a trusted source of events and simplifies the integration process.***

### Enabling integration

In order to enable Cloud Trail integration with one of Klarity Suite applications please follow the onboarding steps described in [prerequisites](#prerequisites) section. Nordcloud Klarity Suite is an AWS partner so it should be possible to select it when creating ingestion channel. This will create required IAM role with trust relationship to the Klarity proxy account (`855341727128`). IAM role can be created manually as well. Just remember to grant all permissions based on this [policy](./policy.json) and add `855341727128` as a trusted account. Once you have created IAM role and Cloud Trail ingestion channel please contact with your CSM and provide following information:

- IAM role arn
- IAM role external ID (optional)
- Ingestion channel ARN 

Please note that at the beginning not all Klarity Suite applications will implement Cloud Trail Events. This will be delivered based on our roadmap and customer requirements. To ask for feature availability please contact with your CSM.

### Event Sources

Single and uniq event source is reserved for each of Klarity Suite application. Currently we have reserved following event sources:

| Application name | Event Source | Integration enabled |
|---|---|:---:|
| Klarity Core | com.nordcloudapp.com.klarity | ❌ |
| Image Factory | com.nordcloudapp.com.imagefactory | ❌ |
| AutoBackup | com.nordcloudapp.com.autobackup | ❌ |
| AutoPatcher | com.nordcloudapp.com.autopatcher | ❌ |
| Maestro | com.nordcloudapp.com.maestro | ❌ |

Please note that the above list may change in the future once we add new applications to the Klarity Suite.

❌ - *Event source name is reserved for the application but integration is not yet implemented.*
✅ - *Integration is fully implemented.*

### Event types

Event types define the activity tododod that happened on application tenant or operation executed by the application on cloud environment. Every application has its own uniq set of event types depending on the functionality. Please check the application specific documentation in [sources](./sources/) directory for more details.

## Architecture

![Integration diagram](img/arch.png)

## Examples

Example events produced by Klarity Suite applications can be found in [sources](./sources/) directory for specific application. fsdfd

## Support

To get support on Klarity Cloud Trail integration please contact with your CSM or create ticket using Klarity Suite JSD.

We strongly encourage you to leave us a feedback regarding this functionality. New applications and events will be delivered based on customer demands.
