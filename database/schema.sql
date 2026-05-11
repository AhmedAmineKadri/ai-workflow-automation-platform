CREATE SCHEMA IF NOT EXISTS app;

CREATE TABLE IF NOT EXISTS app.support_requests (
                                                    id BIGSERIAL PRIMARY KEY,

                                                    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,

    category VARCHAR(100),
    priority VARCHAR(20),
    summary TEXT,
    extracted_data JSONB,
    suggested_reply TEXT,

    approval_status VARCHAR(30) NOT NULL DEFAULT 'PENDING_APPROVAL',

    reviewed_by VARCHAR(100),
    review_comment TEXT,
    reviewed_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT support_requests_priority_check
    CHECK (
              priority IS NULL
              OR priority IN ('low', 'medium', 'high')
    ),

    CONSTRAINT support_requests_approval_status_check
    CHECK (
              approval_status IN (
              'PENDING_APPROVAL',
              'APPROVED',
              'REJECTED'
                                 )
    )
    );
CREATE TABLE IF NOT EXISTS app.workflow_logs (
                                                 id BIGSERIAL PRIMARY KEY,

                                                 workflow_name VARCHAR(100) NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    status VARCHAR(30) NOT NULL,

    support_request_id BIGINT,
    message TEXT,
    metadata JSONB,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT workflow_logs_status_check
    CHECK (
              status IN (
              'SUCCESS',
              'ERROR',
              'WARNING',
              'INFO'
                        )
    ),

    CONSTRAINT workflow_logs_support_request_fk
    FOREIGN KEY (support_request_id)
    REFERENCES app.support_requests(id)
    ON DELETE SET NULL
    );