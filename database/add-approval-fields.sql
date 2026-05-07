ALTER TABLE app.support_requests
    ADD COLUMN IF NOT EXISTS reviewed_by VARCHAR(100),
    ADD COLUMN IF NOT EXISTS review_comment TEXT,
    ADD COLUMN IF NOT EXISTS reviewed_at TIMESTAMPTZ;