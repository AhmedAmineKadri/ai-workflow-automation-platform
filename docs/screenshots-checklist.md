# Screenshots Checklist

This document defines the screenshots I want to collect to present the project clearly in the README, on LinkedIn, in my CV, or during interviews.
---

## Required Screenshots

### 1. Docker Containers Running

Show:

```powershell
docker compose ps
```

Should include:

- `ai_workflow_n8n`
- `ai_workflow_postgres`

Purpose:

Shows that the project runs locally with Docker Compose.

---

### 2. n8n Support Request Workflow

Show the full n8n workflow:

```text
Webhook → Validation → Ollama → Parse AI JSON → PostgreSQL → Logging → Response
```

Purpose:

Shows the main automation flow visually.

---

### 3. n8n Review Approval Workflow

Show the full review workflow:

```text
Webhook → Validation → Status Check → Approval Update → Logging → Response
```

Purpose:

Shows the human-in-the-loop approval process.

---

### 4. Successful Support Request Test

Show terminal command:

```powershell
curl.exe -X POST "http://localhost:5678/webhook/support-request" ...
```

and the JSON response:

```json
{
  "status": "received",
  "approvalStatus": "PENDING_APPROVAL"
}
```

Purpose:

Shows the webhook working.

---

### 5. PostgreSQL Support Request Data

Show query result from:

```sql
SELECT id, customer_name, category, priority, approval_status
FROM app.support_requests
ORDER BY id DESC
LIMIT 10;
```

Purpose:

Shows that AI results are stored in PostgreSQL.

---

### 6. Human Approval Test

Show approval request and response:

```json
{
  "status": "success",
  "message": "Review decision was saved successfully."
}
```

Purpose:

Shows the approval workflow working.

---

### 7. Blocked Review Test

Show error response for an already reviewed request:

```json
{
  "status": "error",
  "message": "Request is not pending approval or does not exist."
}
```

Purpose:

Shows business rule enforcement.

---

### 8. Workflow Logs

Show query result from:

```sql
SELECT id, workflow_name, event_type, status, message
FROM app.workflow_logs
ORDER BY id DESC
LIMIT 20;
```

Purpose:

Shows logging and observability.

---

## Optional Screenshots

### GitHub Repository

Show:

- README
- folder structure
- commit history

### LinkedIn Post

Show the project announcement post.

### Ollama Model

Show:

```powershell
ollama list
```

Purpose:

Shows local LLM usage without OpenAI API cost.

---

## Screenshot Folder Suggestion

Store screenshots locally in:

```text
portfolio-screenshots/
```

Recommended names:

```text
01-docker-containers-running.png
02-n8n-support-workflow.png
03-n8n-review-workflow.png
04-support-request-curl-test.png
05-postgres-support-requests.png
06-review-approval-test.png
07-review-blocked-test.png
08-workflow-logs.png
```

Do not commit screenshots immediately unless they are clean and useful for the README.
