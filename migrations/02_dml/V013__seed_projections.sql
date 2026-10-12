-- The projections as the event stream of the demo leaves them (same ids as the catalog,
-- enrollment and billing seeds): the pensum, the sections of 2026-B and, per student, the subjects passed,
-- the confirmed sections with their schedule and the tuition state (Santiago ISSUED). In a running
-- platform the consumer keeps these rows; the seed starts them consistent. Upsert.
INSERT INTO advisor.catalog_subject_view (subject_id, code, name, credits, semester, prerequisites, updated_at)
VALUES
    ('44444444-4444-4444-8444-444444444401', 'ISW-501', 'Bases de Datos I', 3, 5, '{}', '2026-08-01T12:00:00Z'),
    ('44444444-4444-4444-8444-444444444402', 'ISW-502', 'Sistemas Operativos', 3, 5, '{}', '2026-08-01T12:00:00Z'),
    ('44444444-4444-4444-8444-444444444403', 'RED-501', 'Redes de Datos', 3, 5, '{}', '2026-08-01T12:00:00Z'),
    ('44444444-4444-4444-8444-444444444404', 'HUM-501', 'Ética Profesional', 2, 5, '{}', '2026-08-01T12:00:00Z'),
    ('44444444-4444-4444-8444-444444444405', 'MAT-501', 'Estadística II', 3, 5, '{}', '2026-08-01T12:00:00Z'),
    ('44444444-4444-4444-8444-444444444406', 'ISW-601', 'Bases de Datos II', 3, 6, '{ISW-501}', '2026-08-01T12:00:00Z'),
    ('44444444-4444-4444-8444-444444444407', 'ISW-602', 'Teoría de la Computación', 3, 6, '{}', '2026-08-01T12:00:00Z'),
    ('44444444-4444-4444-8444-444444444408', 'ISW-603', 'Ingeniería de Requisitos', 3, 6, '{}', '2026-08-01T12:00:00Z'),
    ('44444444-4444-4444-8444-444444444409', 'ISW-604', 'Sistemas Distribuidos', 4, 6, '{RED-501}', '2026-08-01T12:00:00Z'),
    ('44444444-4444-4444-8444-444444444410', 'ISW-605', 'Arquitectura de Software', 3, 6, '{}', '2026-08-01T12:00:00Z'),
    ('44444444-4444-4444-8444-444444444411', 'ISW-701', 'Seguridad Informática', 3, 7, '{ISW-604}', '2026-08-01T12:00:00Z'),
    ('44444444-4444-4444-8444-444444444412', 'ISW-702', 'Computación en la Nube', 3, 7, '{ISW-604}', '2026-08-01T12:00:00Z'),
    ('44444444-4444-4444-8444-444444444413', 'ISW-703', 'Gestión de Proyectos', 3, 7, '{}', '2026-08-01T12:00:00Z'),
    ('44444444-4444-4444-8444-444444444414', 'ISW-704', 'Analítica de Datos', 3, 7, '{MAT-501}', '2026-08-01T12:00:00Z')
ON CONFLICT (subject_id) DO UPDATE SET code = EXCLUDED.code, name = EXCLUDED.name, credits = EXCLUDED.credits,
    semester = EXCLUDED.semester, prerequisites = EXCLUDED.prerequisites, updated_at = EXCLUDED.updated_at;

INSERT INTO advisor.catalog_section_view (section_id, subject_code, subject_name, term, group_number, professor_name, slots, seats_available, updated_at)
VALUES
    ('55555555-5555-4555-8555-555555555501', 'ISW-601', 'Bases de Datos II', '2026-B', 1, 'Ana Torres', '[{"day":"TUE","start":"08:00","end":"10:00"},{"day":"THU","start":"08:00","end":"10:00"}]', 29, '2026-08-01T12:00:00Z'),
    ('55555555-5555-4555-8555-555555555502', 'ISW-603', 'Ingeniería de Requisitos', '2026-B', 1, 'Jorge Medina', '[{"day":"MON","start":"10:00","end":"12:00"},{"day":"WED","start":"10:00","end":"12:00"}]', 29, '2026-08-01T12:00:00Z'),
    ('55555555-5555-4555-8555-555555555503', 'ISW-605', 'Arquitectura de Software', '2026-B', 1, 'Ana Torres', '[{"day":"TUE","start":"14:00","end":"16:00"},{"day":"THU","start":"14:00","end":"16:00"}]', 29, '2026-08-01T12:00:00Z'),
    ('55555555-5555-4555-8555-555555555504', 'MAT-501', 'Estadística II', '2026-B', 1, 'Jorge Medina', '[{"day":"FRI","start":"14:00","end":"17:00"}]', 29, '2026-08-01T12:00:00Z'),
    ('55555555-5555-4555-8555-555555555505', 'ISW-604', 'Sistemas Distribuidos', '2026-B', 1, 'Carlos Ramírez', '[{"day":"MON","start":"08:00","end":"10:00"},{"day":"WED","start":"08:00","end":"10:00"}]', 27, '2026-08-01T12:00:00Z'),
    ('55555555-5555-4555-8555-555555555506', 'ISW-604', 'Sistemas Distribuidos', '2026-B', 2, 'Ana Torres', '[{"day":"TUE","start":"08:00","end":"10:00"},{"day":"THU","start":"08:00","end":"10:00"}]', 30, '2026-08-01T12:00:00Z'),
    ('55555555-5555-4555-8555-555555555507', 'ISW-604', 'Sistemas Distribuidos', '2026-B', 3, 'Jorge Medina', '[{"day":"FRI","start":"08:00","end":"12:00"}]', 0, '2026-08-01T12:00:00Z'),
    ('55555555-5555-4555-8555-555555555508', 'ISW-501', 'Bases de Datos I', '2026-B', 2, 'Carlos Ramírez', '[{"day":"TUE","start":"10:00","end":"12:00"},{"day":"THU","start":"10:00","end":"12:00"}]', 0, '2026-08-01T12:00:00Z'),
    ('55555555-5555-4555-8555-555555555509', 'RED-501', 'Redes de Datos', '2026-B', 1, 'Carlos Ramírez', '[{"day":"FRI","start":"08:00","end":"11:00"}]', 30, '2026-08-01T12:00:00Z'),
    ('55555555-5555-4555-8555-555555555510', 'ISW-602', 'Teoría de la Computación', '2026-B', 1, 'Ana Torres', '[{"day":"TUE","start":"16:00","end":"18:00"},{"day":"THU","start":"16:00","end":"18:00"}]', 30, '2026-08-01T12:00:00Z'),
    ('55555555-5555-4555-8555-555555555511', 'ISW-703', 'Gestión de Proyectos', '2026-B', 1, 'Jorge Medina', '[{"day":"WED","start":"16:00","end":"19:00"}]', 30, '2026-08-01T12:00:00Z')
ON CONFLICT (section_id) DO UPDATE SET subject_code = EXCLUDED.subject_code, subject_name = EXCLUDED.subject_name, term = EXCLUDED.term,
    group_number = EXCLUDED.group_number, professor_name = EXCLUDED.professor_name, slots = EXCLUDED.slots,
    seats_available = EXCLUDED.seats_available, updated_at = EXCLUDED.updated_at;

INSERT INTO advisor.student_view (student_id, passed_codes, confirmed_sections, tuition_status, updated_at)
VALUES
    ('11111111-1111-4111-8111-111111111111', '{ISW-501,ISW-502,RED-501,HUM-501}', '[{"sectionId":"55555555-5555-4555-8555-555555555501","subjectCode":"ISW-601","slots":[{"day":"TUE","start":"08:00","end":"10:00"},{"day":"THU","start":"08:00","end":"10:00"}]},{"sectionId":"55555555-5555-4555-8555-555555555502","subjectCode":"ISW-603","slots":[{"day":"MON","start":"10:00","end":"12:00"},{"day":"WED","start":"10:00","end":"12:00"}]},{"sectionId":"55555555-5555-4555-8555-555555555503","subjectCode":"ISW-605","slots":[{"day":"TUE","start":"14:00","end":"16:00"},{"day":"THU","start":"14:00","end":"16:00"}]},{"sectionId":"55555555-5555-4555-8555-555555555504","subjectCode":"MAT-501","slots":[{"day":"FRI","start":"14:00","end":"17:00"}]}]', 'PAID', '2026-08-15T09:00:00Z'),
    ('11111111-1111-4111-8111-111111111112', '{ISW-501}', '[]', 'ISSUED', '2026-08-15T09:00:00Z'),
    ('11111111-1111-4111-8111-111111111113', '{ISW-501,ISW-502,RED-501,HUM-501,MAT-501}', '[{"sectionId":"55555555-5555-4555-8555-555555555505","subjectCode":"ISW-604","slots":[{"day":"MON","start":"08:00","end":"10:00"},{"day":"WED","start":"08:00","end":"10:00"}]}]', 'PAID', '2026-08-15T09:00:00Z'),
    ('11111111-1111-4111-8111-111111111114', '{ISW-501,ISW-502,RED-501,HUM-501,MAT-501,ISW-601}', '[{"sectionId":"55555555-5555-4555-8555-555555555505","subjectCode":"ISW-604","slots":[{"day":"MON","start":"08:00","end":"10:00"},{"day":"WED","start":"08:00","end":"10:00"}]}]', 'PAID', '2026-08-15T09:00:00Z'),
    ('11111111-1111-4111-8111-111111111115', '{ISW-501,ISW-502,RED-501,HUM-501,MAT-501,ISW-601}', '[{"sectionId":"55555555-5555-4555-8555-555555555505","subjectCode":"ISW-604","slots":[{"day":"MON","start":"08:00","end":"10:00"},{"day":"WED","start":"08:00","end":"10:00"}]}]', 'PAID', '2026-08-15T09:00:00Z')
ON CONFLICT (student_id) DO UPDATE SET passed_codes = EXCLUDED.passed_codes, confirmed_sections = EXCLUDED.confirmed_sections,
    tuition_status = EXCLUDED.tuition_status, updated_at = EXCLUDED.updated_at;
