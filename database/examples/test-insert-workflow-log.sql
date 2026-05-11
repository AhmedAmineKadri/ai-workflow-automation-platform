INSERT INTO app.workflow_logs (
    workflow_name,
    event_type,
    status,
    support_request_id,
    message,
    metadata
)
VALUES (
           'manual_test',
           'LOG_TABLE_TEST',
           'SUCCESS',
           NULL,
           'Workflow logging table was created successfully.',
           '{"source": "manual_sql_test"}'::jsonb
       );