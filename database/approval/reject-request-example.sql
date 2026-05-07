UPDATE app.support_requests
SET
    approval_status = 'REJECTED',
    reviewed_by = 'Amine',
    review_comment = 'AI suggestion rejected because it needs manual rewriting.',
    reviewed_at = NOW(),
    updated_at = NOW()
WHERE id = 1;