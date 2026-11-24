CREATE TABLE bolsista (
    matricula INT PRIMARY KEY,
	pnome VARCHAR(100) NOT NULL,
	mnome VARCHAR(100),
	unome VARCHAR(100),
	editor BOOL,
	anotador BOOL,
    email VARCHAR(100) UNIQUE NOT NULL,
	CHECK (editor = TRUE OR anotador = TRUE)
);

CREATE TABLE entrevista (
	codigo INT PRIMARY KEY,
	fase VARCHAR(100) NOT NULL
);

CREATE TABLE entrevistado (
    CPF VARCHAR(14) PRIMARY KEY,
	pnome VARCHAR(100) NOT NULL,
	mnome VARCHAR(100),
	unome VARCHAR(100),
	datanasc DATE NOT NULL,
	codigo_entrevista INT NOT NULL REFERENCES entrevista(codigo)
);

CREATE TABLE etapa (
	id INT PRIMARY KEY,
	tipo VARCHAR(100) NOT NULL,
	andamento VARCHAR(100),
	video VARCHAR(255),
	cpf_entrevistado1 VARCHAR(14) NOT NULL REFERENCES entrevistado(cpf),
	cpf_entrevistado2 VARCHAR(14) REFERENCES entrevistado(cpf),
	codigo_entrevista INT NOT NULL REFERENCES entrevista(codigo),
	CHECK (cpf_entrevistado1 <> cpf_entrevistado2)
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


