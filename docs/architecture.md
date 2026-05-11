# Architecture

This document explains the current architecture of the AI Workflow Automation Platform.

The project is built as a local workflow automation system using n8n, Ollama, PostgreSQL, and Docker Compose.

---

## High-Level Architecture

```text
Customer / Test Client
        |
        | POST /support-request
        v
n8n Support Request Workflow
        |
        | validate input
        v
Ollama Local LLM
        |
        | classify + summarize + extract JSON + suggest reply
        v
n8n Parse AI Result
        |
        | save request and AI result
        v
PostgreSQL
        |
        | approval_status = PENDING_APPROVAL
        v
Human Review Workflow
        |
        | POST /review-request
        v
Approve / Reject Request
        |
        v
Workflow Logs in PostgreSQL
```

---

## Main Components

### n8n

n8n is the workflow automation tool.

It controls the business process:

- receives webhook requests
- validates input
- calls Ollama
- parses AI output
- writes data to PostgreSQL
- handles human review decisions
- writes workflow logs

---

### Ollama

Ollama runs the local LLM.

The current model is:

```text
llama3.2:3b
```

It is used to analyze customer support messages and generate:

- category
- priority
- summary
- extracted structured data
- suggested customer reply

The project uses Ollama locally instead of the OpenAI API to avoid API costs during development.

---

### PostgreSQL

PostgreSQL stores the business data.

Main tables:

```text
app.support_requests
app.workflow_logs
```

`app.support_requests` stores customer requests, AI results, approval status, and reviewer information.

`app.workflow_logs` stores important workflow events for debugging and traceability.

---

### Docker Compose

Docker Compose starts the local infrastructure:

```text
n8n container
PostgreSQL container
```

Ollama runs locally on Windows and is reached from the n8n Docker container through:

```text
http://host.docker.internal:11434
```

---

## Workflow 1: Support Request Workflow

This workflow receives customer support requests.

```text
Webhook
   ↓
Input Validation
   ↓
IF Input Valid?
   ├── false → Log Validation Failed → Return Error Response
   ↓ true
Ollama AI Analysis
   ↓
Parse AI JSON
   ↓
PostgreSQL Insert
   ↓
Log Request Saved
   ↓
Webhook Response
```

### Purpose

The workflow automates the first analysis of a customer request.

It does not send a final answer to the customer.

Instead, it saves the AI-generated suggestion with:

```text
PENDING_APPROVAL
```

---

## Workflow 2: Review Approval Workflow

This workflow allows a human reviewer to approve or reject an AI-generated suggestion.

```text
Webhook
   ↓
Review Input Validation
   ↓
IF Review Input Valid?
   ├── false → Log Review Validation Failed → Return Error Response
   ↓ true
Check Request Status in PostgreSQL
   ↓
IF Request Can Be Reviewed?
   ├── false → Log Review Blocked → Return Conflict Response
   ↓ true
Update to APPROVED or REJECTED
   ↓
Log Review Completed
   ↓
Webhook Response
```

### Purpose

This workflow implements the human-in-the-loop step.

A request can only be reviewed if it is still:

```text
PENDING_APPROVAL
```

Already approved or rejected requests cannot be updated again.

---

## Database Tables

### app.support_requests

Stores support request data.

Important columns:

```text
id
customer_name
customer_email
message
category
priority
summary
extracted_data
suggested_reply
approval_status
reviewed_by
review_comment
reviewed_at
created_at
updated_at
```

Allowed approval states:

```text
PENDING_APPROVAL
APPROVED
REJECTED
```

---

### app.workflow_logs

Stores workflow events.

Important columns:

```text
id
workflow_name
event_type
status
support_request_id
message
metadata
created_at
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

## Human-in-the-Loop Design

The system intentionally does not send AI-generated replies directly to customers.

Instead:

```text
AI generates suggestion
        ↓
Suggestion is stored as PENDING_APPROVAL
        ↓
Human reviewer checks it
        ↓
Reviewer approves or rejects
```

This makes the system safer and more realistic for business use cases.

---

## Error Handling and Safety

The project includes basic safety and validation logic:

- invalid support requests are rejected before calling the LLM
- invalid review requests are rejected before database updates
- AI JSON parsing has fallback behavior
- only pending requests can be reviewed
- already approved or rejected requests cannot be changed again
- important workflow events are logged in PostgreSQL

---

## Future Architecture Extensions

Possible future improvements:

- Spring Boot backend for approval APIs
- admin dashboard for reviewing requests
- authentication for reviewers
- email or Slack notifications
- OpenAI API provider as an alternative to Ollama
- deployment documentation
- Swagger/OpenAPI documentation
- more advanced monitoring and error handling