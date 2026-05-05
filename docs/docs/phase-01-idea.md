# Phase 1 — Project Idea

## What is workflow automation?

Workflow automation means using software to automatically execute steps that would normally be done manually.

In this project, a customer support request will be processed automatically.

Example manual process:

1. Read the customer message.
2. Identify the category.
3. Extract important information.
4. Write a short summary.
5. Suggest an answer.
6. Store the case.
7. Wait for human approval.

The goal of this project is to automate these steps using n8n and an LLM.

## What is n8n?

n8n is a workflow automation tool.

It allows us to connect different systems using visual building blocks called nodes.

Examples of nodes:

- Webhook node
- HTTP Request node
- PostgreSQL node
- IF node
- Code node

In this project, n8n controls the full process:

Receive request → Analyze with AI → Save in database → Wait for approval.

## Why this project is useful

This project is useful because many companies want to automate repetitive business processes using AI.

It shows practical skills in:

- workflow automation
- LLM integration
- REST APIs and webhooks
- PostgreSQL
- Docker
- human-in-the-loop AI
- business process thinking