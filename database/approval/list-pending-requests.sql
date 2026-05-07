SELECT
    id,
    customer_name,
    customer_email,
    category,
    priority,
    summary,
    suggested_reply,
    approval_status,
    created_at
FROM app.support_requests
WHERE approval_status = 'PENDING_APPROVAL'
ORDER BY created_at DESC;