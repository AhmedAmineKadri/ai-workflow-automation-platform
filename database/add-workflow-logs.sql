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