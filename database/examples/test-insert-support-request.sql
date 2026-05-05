INSERT INTO app.support_requests (
    customer_name,
    customer_email,
    message,
    category,
    priority,
    summary,
    extracted_data,
    suggested_reply
)
VALUES (
           'Max Müller',
           'max@example.com',
           'Hi, my order #A123 arrived damaged. Can I get a replacement?',
           'damaged_product',
           'medium',
           'Customer reports that order A123 arrived damaged and asks for a replacement.',
           '{"orderNumber": "A123", "requestedAction": "replacement"}'::jsonb,
           'Hello Max, thank you for contacting us. We will check your case and get back to you shortly.'
       );