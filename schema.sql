CREATE TABLE bolsista (
    pnome VARCHAR(100) NOT NULL,
	mnome VARCHAR(100),
	unome VARCHAR(100),
	matricula INT NOT NULL,
	editor BOOL,
	anotador BOOL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE entrevistado (
    pnome VARCHAR(100) NOT NULL,
	mnome VARCHAR(100),
	unome VARCHAR(100),
	datanasc DATE NOT NULL,
	CPF VARCHAR(14) NOT NULL,
	codigo_entrevista INT NOT NULL REFERENCES entrevista(codigo)
);

CREATE TABLE entrevista (
	codigo INT NOT NULL,
	fase VARCHAR(100) NOT NULL
);

CREATE TABLE etapa (
	tipo VARCHAR(100) NOT NULL,
	andamento VARCHAR(100),
	video VARCHAR(255),
	cpf_entrevistado1 VARCHAR(14) NOT NULL REFERENCES entrevistado(cpf),
	cpf_entrevistado2 VARCHAR(14) REFERENCES entrevistado(cpf),
	CHECK (cpf_entrevistado1 <> cpf_entrevistado2)
);


