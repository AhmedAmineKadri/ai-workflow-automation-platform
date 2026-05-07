UPDATE app.support_requests
SET
    approval_status = 'APPROVED',
    reviewed_by = 'Amine',
    review_comment = 'AI suggestion reviewed and approved.',
    reviewed_at = NOW(),
    updated_at = NOW()
WHERE id = 1;