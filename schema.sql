CREATE TABLE bolsista (
    matricula INT PRIMARY KEY,
	pnome VARCHAR(100) NOT NULL,
	mnome VARCHAR(100),
	unome VARCHAR(100),
	editor BOOLEAN NOT NULL DEFAULT FALSE,
	anotador BOOLEAN NOT NULL DEFAULT FALSE,
    email VARCHAR(100) UNIQUE NOT NULL,
	CHECK (editor = TRUE OR anotador = TRUE)
);

CREATE TABLE entrevista (
	codigo INT PRIMARY KEY,
	fase VARCHAR(100) NOT NULL,
	dia DATE NOT NULL
);

CREATE TABLE entrevistado (
    CPF VARCHAR(14) PRIMARY KEY,
	pnome VARCHAR(100) NOT NULL,
	mnome VARCHAR(100),
	unome VARCHAR(100),
	datanasc DATE NOT NULL,
	codigo_entrevista INT NOT NULL REFERENCES entrevista(codigo),
	UNIQUE (cpf, codigo_entrevista)
);

CREATE TABLE etapa (
	id INT PRIMARY KEY,
	tipo VARCHAR(100) NOT NULL,
	andamento VARCHAR(100),
	video VARCHAR(255),
	cpf_entrevistado1 VARCHAR(14) NOT NULL,
	cpf_entrevistado2 VARCHAR(14),
	codigo_entrevista INT NOT NULL REFERENCES entrevista(codigo),
	CHECK (cpf_entrevistado1 <> cpf_entrevistado2),
	FOREIGN KEY (cpf_entrevistado1, codigo_entrevista) REFERENCES entrevistado(CPF, codigo_entrevista),
	FOREIGN KEY (cpf_entrevistado2, codigo_entrevista) REFERENCES entrevistado(CPF, codigo_entrevista)
);

CREATE TABLE edita (
	matricula_bolsista INT NOT NULL REFERENCES bolsista(matricula),
	id_etapa INT NOT NULL REFERENCES etapa(id),
	PRIMARY KEY (matricula_bolsista, id_etapa)
);

CREATE TABLE anota (
	matricula_bolsista INT NOT NULL REFERENCES bolsista(matricula),
	id_etapa INT NOT NULL REFERENCES etapa(id),
	PRIMARY KEY (matricula_bolsista, id_etapa)
);

--funcao para verificar se o bolsista é editor ou anotador antes de inserir na tabela edita ou anota

CREATE OR REPLACE FUNCTION check_bolsista_role()
RETURNS TRIGGER AS $$
DECLARE
	is_editor BOOLEAN;
	is_anotador BOOLEAN;
	role_of_bolsista TEXT := TG_ARGV[0];
BEGIN
	SELECT editor, anotador INTO is_editor, is_anotador FROM bolsista WHERE matricula = NEW.matricula_bolsista;

	IF role_of_bolsista = 'editor' AND NOT is_editor THEN
		RAISE EXCEPTION 'Bolsista com matricula % não é um editor.', NEW.matricula_bolsista;
	END IF;

	IF role_of_bolsista = 'anotador' AND NOT is_anotador THEN
		RAISE EXCEPTION 'Bolsista com matricula % não é um anotador.', NEW.matricula_bolsista;
	END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_editor_role
BEFORE INSERT OR UPDATE ON edita
FOR EACH ROW EXECUTE FUNCTION check_bolsista_role('editor');

CREATE TRIGGER check_anotador_role
BEFORE INSERT OR UPDATE ON anota
FOR EACH ROW EXECUTE FUNCTION check_bolsista_role('anotador');

--funcao para verificar se o entrevistado tem mais de 18 anos antes de inserir na tabela entrevistado

CREATE OR REPLACE FUNCTION validar_maioridade_entrevistado()
RETURNS TRIGGER AS $$
DECLARE
	data_entrevista DATE;
BEGIN
	SELECT dia INTO data_entrevista FROM entrevista WHERE codigo = NEW.codigo_entrevista;
    IF EXTRACT(YEAR FROM AGE(data_entrevista, NEW.datanasc)) < 18 THEN
        RAISE EXCEPTION 'O entrevistado precisa ter no mínimo 18 anos.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_maioridade
BEFORE INSERT OR UPDATE ON entrevistado
FOR EACH ROW
EXECUTE FUNCTION validar_maioridade_entrevistado();

--view para exibir os entrevistados com idade e faixa etária calculadas

CREATE OR REPLACE VIEW vw_entrevistados AS
SELECT
    e.cpf,
    e.pnome,
    e.mnome,
    e.unome,
    e.datanasc,
    EXTRACT(YEAR FROM AGE(et.dia, e.datanasc))::INT AS idade_entrevista,
    CASE
        WHEN EXTRACT(YEAR FROM AGE(et.dia, e.datanasc)) BETWEEN 18 AND 29 THEN '18-29'
        WHEN EXTRACT(YEAR FROM AGE(et.dia, e.datanasc)) BETWEEN 30 AND 39 THEN '30-39'
        WHEN EXTRACT(YEAR FROM AGE(et.dia, e.datanasc)) >= 40 THEN '40+'
        ELSE 'Menor de 18'
    END AS faixa_etaria,
    e.codigo_entrevista,
    et.fase
FROM entrevistado e
JOIN entrevista et ON e.codigo_entrevista = et.codigo;