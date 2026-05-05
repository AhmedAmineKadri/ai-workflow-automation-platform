# Architecture Version 1

## Simple Architecture

```text
Test Client
curl / Postman
     |
     | POST support request
     v
n8n Webhook Trigger
     |
     v
Basic Validation
     |
     v
LLM API
classification + extraction + summary + suggested reply
     |
     v
PostgreSQL
store request and AI result
     |
     v
Webhook Response
return status to caller