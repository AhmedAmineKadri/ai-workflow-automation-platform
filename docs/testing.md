# Testing Guide

This document explains how to test the AI Workflow Automation Platform locally.

The project contains two main n8n workflows:

1. Support Request Workflow
2. Review Approval Workflow

It also stores workflow logs in PostgreSQL.

---

## 1. Start the System

Start Docker services:

```powershell
docker compose up -d
```

Check containers:

```powershell
docker compose ps
```

Expected containers:

```text
ai_workflow_n8n
ai_workflow_postgres
```

Check Ollama:

```powershell
ollama list
```

Expected model:

```text
llama3.2:3b
```

Test Ollama API:

```powershell
curl.exe http://localhost:11434/api/tags
```

Open n8n:

```text
http://localhost:5678
```

---

## 2. Test Support Request Workflow

The support request workflow receives a customer request, validates it, analyzes it with Ollama, saves it in PostgreSQL, logs the event, and returns a response.

### Active Webhook URL

```text
http://localhost:5678/webhook/support-request
```

### Test Request

```powershell
curl.exe -X POST "http://localhost:5678/webhook/support-request" `
  -H "Content-Type: application/json" `
  --data-binary "@examples/support-request-urgent.json"
```

### Expected Response

```json
{
  "status": "received",
  "approvalStatus": "PENDING_APPROVAL",
  "message": "Request was analyzed by Ollama and saved for human review."
}
```

### Verify Database Insert

```powershell
docker compose exec postgres psql -U n8n_user -d n8n_db -P pager=off -c "SELECT id, customer_name, category, priority, approval_status FROM app.support_requests ORDER BY id DESC LIMIT 10;"
```

Expected result:

```text
A new support request with approval_status = PENDING_APPROVAL
```

---

## 3. Test Invalid Support Request

### Test Request

```powershell
curl.exe -X POST "http://localhost:5678/webhook/support-request" `
  -H "Content-Type: application/json" `
  --data-binary "@examples/support-request-invalid.json"
```

### Expected Response

```json
{
  "status": "error",
  "message": "Invalid support request input.",
  "errors": [
    "customerName is required",
    "email is required",
    "message must be at least 10 characters long"
  ]
}
```

### Verify Validation Log

```powershell
docker compose exec postgres psql -U n8n_user -d n8n_db -P pager=off -c "SELECT id, workflow_name, event_type, status, message, metadata FROM app.workflow_logs ORDER BY id DESC LIMIT 10;"
```

Expected log event:

```text
VALIDATION_FAILED
```

---

## 4. Test Review Approval Workflow

The review workflow allows a human reviewer to approve or reject an AI-generated support suggestion.

### Active Webhook URL

```text
http://localhost:5678/webhook/review-request
```

Before testing, find a pending request:

```powershell
docker compose exec postgres psql -U n8n_user -d n8n_db -P pager=off -c "SELECT id, customer_name, approval_status FROM app.support_requests WHERE approval_status = 'PENDING_APPROVAL' ORDER BY id DESC;"
```

Update the `requestId` inside:

```text
examples/review-request-approve.json
```

### Test Approval Request

```powershell
curl.exe -X POST "http://localhost:5678/webhook/review-request" `
  -H "Content-Type: application/json" `
  --data-binary "@examples/review-request-approve.json"
```

### Expected Response

```json
{
  "status": "success",
  "message": "Review decision was saved successfully.",
  "requestId": 8,
  "decision": "APPROVED",
  "reviewedBy": "Amine"
}
```

### Verify Approval in Database

```powershell
docker compose exec postgres psql -U n8n_user -d n8n_db -P pager=off -c "SELECT id, customer_name, approval_status, reviewed_by, review_comment FROM app.support_requests ORDER BY id DESC LIMIT 10;"
```

Expected result:

```text
The selected request is now APPROVED.
```

---

## 5. Test Blocked Review

A request that is already `APPROVED` or `REJECTED` should not be updated again.

Use an already reviewed request ID in:

```text
examples/review-request-approve.json
```

Then run:

```powershell
curl.exe -X POST "http://localhost:5678/webhook/review-request" `
  -H "Content-Type: application/json" `
  --data-binary "@examples/review-request-approve.json"
```

### Expected Response

```json
{
  "status": "error",
  "message": "Request is not pending approval or does not exist.",
  "requestId": 7,
  "currentStatus": "REJECTED",
  "errors": [
    "request is already REJECTED"
  ]
}
```

### Expected Log Event

```text
REVIEW_BLOCKED
```

---

## 6. Test Invalid Review Input

### Test Request

```powershell
curl.exe -X POST "http://localhost:5678/webhook/review-request" `
  -H "Content-Type: application/json" `
  --data-binary "@examples/review-request-invalid.json"
```

### Expected Response

```json
{
  "status": "error",
  "message": "Invalid review request input.",
  "errors": [
    "requestId must be a positive integer",
    "decision must be APPROVED or REJECTED",
    "reviewedBy is required"
  ]
}
```

### Expected Log Event

```text
REVIEW_VALIDATION_FAILED
```

---

## 7. Show Workflow Logs

```powershell
docker compose exec postgres psql -U n8n_user -d n8n_db -P pager=off -c "SELECT id, workflow_name, event_type, status, support_request_id, message, metadata, created_at FROM app.workflow_logs ORDER BY id DESC LIMIT 20;"
```

Important event types:

```text
VALIDATION_FAILED
REQUEST_SAVED
REVIEW_VALIDATION_FAILED
REVIEW_BLOCKED
REVIEW_COMPLETED
```

---

## 8. Stop the System

Stop containers without deleting data:

```powershell
docker compose stop
```

Do not use this unless you intentionally want to delete Docker volumes:

```powershell
docker compose down -v
```