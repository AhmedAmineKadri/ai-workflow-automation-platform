# Phase 2 — MVP Definition

## MVP Name

AI Support Request Triage Workflow

## Goal

The MVP should receive a customer support request, analyze it with an LLM, save the result in PostgreSQL, and mark it as pending human approval.

## Input Example

```json
{
  "customerName": "Max Müller",
  "email": "max@example.com",
  "message": "Hi, my order #A123 arrived damaged. Can I get a replacement?"
}
```

## Output Example
```json
{
  "category": "damaged_product",
  "priority": "medium",
  "summary": "Customer reports that order A123 arrived damaged and asks for a replacement.",
  "extractedData": {
    "orderNumber": "A123",
    "requestedAction": "replacement"
  },
  "suggestedReply": "Hello Max, thank you for contacting us. I am sorry that your order arrived damaged. We will check your case and get back to you shortly."
}

```

## Final Webhook Response Example
```json
{
  "status": "received",
  "approvalStatus": "PENDING_APPROVAL",
  "message": "Request was analyzed and saved for human review."
}