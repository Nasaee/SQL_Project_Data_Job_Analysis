INSERT INTO job_applied (
    job_id,
    application_send_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status
) VALUES
    (1, '2024-02-01', true,  'resume_01.pdf', true,  'cover_letter_01.pdf', 'submitted'),
    (2, '2024-02-05', false, 'resume_02.pdf', true,  'cover_letter_02.pdf', 'in_review'),
    (3, '2024-02-10', true,  'resume_03.pdf', false, NULL,                   'rejected'),
    (4, '2024-02-15', false, 'resume_04.pdf', true,  'cover_letter_04.pdf', 'submitted'),
    (5, '2024-02-20', true,  'resume_05.pdf', true,  'cover_letter_05.pdf', 'accepted');


