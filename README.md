# AI Workflow Automation Platform with n8n + LLMs

This is a student portfolio project for building a realistic AI-powered workflow automation system.

The goal is to automate incoming customer/support requests using:

- n8n for workflow automation
- LLMs for classification, summarization, JSON extraction, and suggested replies
- PostgreSQL for storing requests and AI results
- Docker Compose for local development
- Webhooks and REST-style input
- Human approval before any final customer response is accepted

## MVP

The first MVP is an AI Support Request Triage Workflow.

It will:

1. Receive a support request through a webhook.
2. Validate the basic input.
3. Send the message to an LLM.
4. Classify the request.
5. Extract structured JSON.
6. Generate an internal summary.
7. Generate a suggested customer reply.
8. Save the original request and AI result in PostgreSQL.
9. Mark the result as `PENDING_APPROVAL`.
10. Return a simple response to the caller.

## Important Design Decision

The system will not send AI-generated replies directly to customers in the first version.

Every AI-generated reply must first be reviewed by a human.

## Status

Current phase: Project setup and MVP definition.