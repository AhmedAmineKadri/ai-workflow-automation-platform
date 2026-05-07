# AI Workflow Automation Platform with n8n + LLMs

This is a student portfolio project that demonstrates how to build a realistic AI-powered workflow automation system.

The system automates incoming customer/support requests using n8n, a local LLM with Ollama, PostgreSQL, Docker Compose, webhooks, and a human approval step.

The main goal is not to let AI fully replace a human support agent. Instead, the AI prepares a structured suggestion, and a human reviewer must approve or reject it before it is accepted.

---

## Project Goal

A company receives customer/support requests through a webhook.

The system should:

1. Receive a customer support request.
2. Validate the incoming input.
3. Analyze the message with a local LLM.
4. Classify the request.
5. Extract structured information as JSON.
6. Generate a short internal summary.
7. Generate a suggested customer reply.
8. Store the original request and AI result in PostgreSQL.
9. Mark the request as `PENDING_APPROVAL`.
10. Allow a human reviewer to approve or reject the AI-generated suggestion.

---

## Why This Project Is Useful

This project is designed as a realistic portfolio project for Werkstudent and entry-level IT roles in Germany, especially in areas such as:

- AI automation
- Workflow automation
- Generative AI / LLM integration
- Business process automation
- Backend development
- Digital transformation
- Java/Spring Boot extension possibilities
- Human-in-the-loop AI systems

It shows practical experience with APIs, databases, Docker, n8n workflows, local LLMs, validation, error handling, and approval logic.

---

## Tech Stack

- **n8n** — workflow automation
- **Ollama** — local LLM provider
- **llama3.2:3b** — local language model used for testing
- **PostgreSQL** — stores support requests and AI results
- **Docker Compose** — local infrastructure setup
- **Webhooks** — REST-style workflow input
- **GitHub** — version control and documentation

---

## Current Features

### 1. Support Request Workflow

The first workflow receives a customer support request, sends it to Ollama for AI analysis, parses the AI response, stores the result in PostgreSQL, and returns a response to the caller.

Workflow:

```text
Webhook
   ↓
Input Validation
   ↓
Ollama AI Analysis
   ↓
Parse AI JSON
   ↓
PostgreSQL Insert
   ↓
Webhook Response
```

Example input:

```json
{
  "customerName": "Sarah Klein",
  "email": "sarah@example.com",
  "message": "This is unacceptable. I paid for express delivery and my order is still missing. I need help immediately."
}
```

Example response:

```json
{
  "status": "received",
  "approvalStatus": "PENDING_APPROVAL",
  "message": "Request was analyzed by Ollama and saved for human review."
}
```

---

### 2. Review Approval Workflow

The second workflow allows a human reviewer to approve or reject an AI-generated support suggestion.

Workflow:

```text
Webhook
   ↓
Review Input Validation
   ↓
Check Request Status in PostgreSQL
   ↓
If request is PENDING_APPROVAL
   ↓
Update to APPROVED or REJECTED
   ↓
Webhook Response
```

Example approval request:

```json
{
  "requestId": 8,
  "decision": "APPROVED",
  "reviewedBy": "Amine",
  "comment": "AI suggestion reviewed and approved."
}
```

Example success response:

```json
{
  "status": "success",
  "message": "Review decision was saved successfully.",
  "requestId": 8,
  "decision": "APPROVED",
  "reviewedBy": "Amine"
}
```

Example error response for an already reviewed request:

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

---

## Database Design

The main table is:

```text
app.support_requests
```

It stores:

- original customer name
- customer email
- original message
- AI-generated category
- AI-generated priority
- AI-generated summary
- extracted JSON data
- suggested customer reply
- approval status
- reviewer information
- review comment
- review timestamp
- created/updated timestamps

Approval states:

```text
PENDING_APPROVAL
APPROVED
REJECTED
```

The system only allows review updates when a request is still `PENDING_APPROVAL`.

---

## Important Design Decision

The system does **not** automatically send AI-generated replies to customers.

Every AI-generated reply must first be reviewed by a human.

This makes the project safer and more realistic for business use cases.

---

## Local Setup

### 1. Start Docker services

```powershell
docker compose up -d
```

This starts:

- n8n
- PostgreSQL

### 2. Open n8n

```text
http://localhost:5678
```

### 3. Check running containers

```powershell
docker compose ps
```

### 4. Check Ollama

```powershell
ollama list
```

The project currently uses:

```text
llama3.2:3b
```

### 5. Test Ollama API

```powershell
curl.exe http://localhost:11434/api/tags
```

---

## Example Requests

Support request and review request examples are stored in:

```text
examples/
```

Examples include:

- normal support request
- refund request
- technical issue
- urgent delivery issue
- invalid support request
- review approval request
- review rejection request
- invalid review request

---

## Useful Test Commands

### Send support request

```powershell
curl.exe -X POST "http://localhost:5678/webhook/support-request" `
  -H "Content-Type: application/json" `
  --data-binary "@examples/support-request-urgent.json"
```

### Review request

```powershell
curl.exe -X POST "http://localhost:5678/webhook/review-request" `
  -H "Content-Type: application/json" `
  --data-binary "@examples/review-request-approve.json"
```

### Show latest requests

```powershell
docker compose exec postgres psql -U n8n_user -d n8n_db -P pager=off -c "SELECT id, customer_name, category, priority, approval_status, reviewed_by FROM app.support_requests ORDER BY id DESC LIMIT 10;"
```

### Show pending requests

```powershell
docker compose exec postgres psql -U n8n_user -d n8n_db -P pager=off -c "SELECT id, customer_name, category, priority, approval_status FROM app.support_requests WHERE approval_status = 'PENDING_APPROVAL' ORDER BY id DESC;"
```

### Show reviewed requests

```powershell
docker compose exec postgres psql -U n8n_user -d n8n_db -P pager=off -c "SELECT id, customer_name, approval_status, reviewed_by, review_comment FROM app.support_requests WHERE approval_status IN ('APPROVED', 'REJECTED') ORDER BY id DESC;"
```

---

## Project Structure

```text
ai-workflow-automation-platform/
│
├── database/
│   ├── schema.sql
│   ├── add-approval-fields.sql
│   ├── examples/
│   └── approval/
│
├── docs/
│   ├── architecture-v1.md
│   ├── phase-01-idea.md
│   └── phase-02-mvp.md
│
├── examples/
│   ├── support-request.json
│   ├── support-request-refund.json
│   ├── support-request-technical.json
│   ├── support-request-urgent.json
│   ├── support-request-invalid.json
│   ├── review-request-approve.json
│   ├── review-request-reject.json
│   └── review-request-invalid.json
│
├── n8n/
│   ├── support-request-intake-workflow-v1.json
│   ├── support-request-intake-workflow-v2.json
│   ├── support-request-intake-workflow-v3.json
│   └── review-support-request-workflow-v1.json
│
├── docker-compose.yml
├── .env.example
├── .gitignore
└── README.md
```

---

## Completed Milestones

- Defined project idea and MVP scope
- Created Docker Compose setup for n8n and PostgreSQL
- Created PostgreSQL schema for support requests
- Built first n8n webhook workflow
- Integrated Ollama as local LLM provider
- Added AI classification, summary, JSON extraction, and suggested reply generation
- Added input validation
- Added safer AI JSON parsing
- Added manual human approval fields in PostgreSQL
- Built separate review approval workflow
- Added protection against updating already approved/rejected requests

---

## Next Improvements

Planned next steps:

1. Improve logging and error handling.
2. Store workflow errors in a separate database table.
3. Add better documentation and screenshots.
4. Add an architecture diagram.
5. Add a simple Spring Boot backend later for approval APIs.
6. Add a small admin dashboard later.
7. Add Swagger/OpenAPI documentation if Spring Boot is added.
8. Add authentication for reviewer actions.
9. Add optional email or Slack notification.
10. Add optional OpenAI API provider next to Ollama.

---

## Current Status

Current phase:

```text
Human-in-the-loop workflow completed.
Next phase: error handling, logging, documentation, and portfolio presentation.
```
