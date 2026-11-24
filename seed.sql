TRUNCATE TABLE anota, edita, etapa, entrevistado, entrevista, bolsista RESTART IDENTITY CASCADE;

INSERT INTO bolsista (matricula, pnome, mnome, unome, editor, anotador, email) VALUES
(24200121, 'Luisa', 'Carvalho', 'Bohm', TRUE, TRUE, 'luisa.bohm@example.com'),
(24200122, 'Laila', 'Kauane', NULL, TRUE, FALSE, 'laila.kauane@example.com'),
(24200123, 'Dirceu', NULL, NULL, FALSE, TRUE, 'dirceu.bohm@example.com'),
(24200124, 'Arthur', 'Castro', 'Kaster', TRUE, TRUE, 'arthur.kaster@example.com'),
(24200125, 'Daniele', NULL, NULL, FALSE, TRUE, 'daniele@example.com'),
(24200126, 'Ester', NULL, 'Aires', FALSE, TRUE, 'ester.aires@example.com'),
(24200127, 'Larissa', NULL, NULL, FALSE, TRUE, 'larissa@example.com'),
(24200128, 'Rai', 'Leon', 'Souza', FALSE, TRUE, 'rai.souza@example.com');

INSERT INTO entrevista (codigo, fase) VALUES
(1, 'EDITADO', '2026-01-15'),
(2, 'EDIÇÃO', '2026-02-20'),
(3, 'EDIÇÃO', '2026-03-10'),
(4, 'EDITADO', '2026-04-01');

INSERT INTO entrevistado (CPF, pnome, mnome, unome, datanasc, codigo_entrevista) VALUES
('123.456.789-00', 'Arthur', 'Castro', 'Kaster', '1990-01-01', 1),
('987.654.321-00', 'Joabe', 'Silva', 'Santos', '1990-05-15', 1),
('456.789.123-00', 'Stefanie', 'Almeida', 'Oliveira', '1992-09-10', 2),
('321.654.987-00', 'Milena', 'Silva', 'Santos', '1992-12-20', 2),
('789.123.456-00', 'Diogo', 'Silva', 'Madeira', '1978-03-05', 3),
('654.987.321-00', 'Jean', 'Michel', 'Carrett', '1980-07-25', 3),
('111.222.333-44', 'Gabriele', 'Zitzke', 'Schuch', '1996-11-30', 4),
('555.666.777-88', 'Lauren', 'Costa', 'Pereira', '1998-02-14', 4);

INSERT INTO etapa (id, tipo, andamento, video, cpf_entrevistado1, cpf_entrevistado2, codigo_entrevista) VALUES
(1, 'Conversação', 'ANOTAÇÃO', 'video1.mp4', '123.456.789-00', '987.654.321-00', 1),
(2, 'Narrativa', 'ANOTAÇÃO', 'video2.mp4', '123.456.789-00', '987.654.321-00', 1),
(3, 'Entrevista', 'ANOTAÇÃO', 'video3.mp4', '123.456.789-00', NULL, 1),
(4, 'Entrevista', 'TRADUÇÃO', 'video4.mp4', '987.654.321-00', NULL, 1),
(5, 'Vocabulário', 'TRADUÇÃO', 'video5.mp4', '987.654.321-00', NULL, 1),
(6, 'Vocabulário', 'REVISÃO', 'video6.mp4', '123.456.789-00', NULL, 1),
(7, 'Conversação', 'REVISÃO', 'video7.mp4', '111.222.333-44', '555.666.777-88', 4),
(8, 'Narrativa', 'CONCLUÍDA', 'video8.mp4', '111.222.333-44', '555.666.777-88', 4);

INSERT INTO edita (matricula_bolsista, id_etapa) VALUES
(24200121, 1),
(24200122, 2),
(24200121, 3),
(24200122, 4),
(24200121, 5),
(24200124, 6),
(24200124, 7),
(24200122, 8);

INSERT INTO anota (matricula_bolsista, id_etapa) VALUES
(24200123, 1),
(24200125, 2),
(24200126, 3),
(24200127, 4),
(24200128, 5),
(24200123, 6),
(24200125, 7),
(24200126, 8);

