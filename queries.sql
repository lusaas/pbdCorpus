-- seleciona todos os entrevistados com suas informações, incluindo idade na data da entrevista e faixa etária

SELECT
    cpf,
    CONCAT_WS(' ', pnome, mnome, unome) AS nome_completo,
    datanasc as data_nascimento,
    dia_entrevista,
    idade_entrevista,
    faixa_etaria,
    codigo_entrevista,
    fase AS fase_entrevista
FROM vw_entrevistados
ORDER BY codigo_entrevista, nome_completo;

-- seleciona a quantidade de entrevistados por faixa etária

SELECT
    faixa_etaria,
    COUNT(*) AS quantidade_entrevistados
FROM vw_entrevistados
GROUP BY faixa_etaria
ORDER BY faixa_etaria;

-- seleciona todas as etapas com suas informações, incluindo modalidade (individual ou dupla) e nomes dos entrevistados

SELECT
    et.id AS id_etapa,
    e.codigo AS codigo_entrevista,
    e.dia AS data_entrevista,
    et.tipo AS tipo_etapa,
    et.andamento,
    et.video,
    CASE
        WHEN et.cpf_entrevistado2 IS NOT NULL THEN 'Dupla'
        ELSE 'Individual'
    END AS modalidade,
    CONCAT_WS(' ', ent1.pnome, ent1.mnome, ent1.unome) AS entrevistado1,
    CONCAT_WS(' ', ent2.pnome, ent2.mnome, ent2.unome) AS entrevistado2
FROM etapa et
JOIN entrevista e ON et.codigo_entrevista = e.codigo
JOIN entrevistado ent1 ON et.cpf_entrevistado1 = ent1.cpf
LEFT JOIN entrevistado ent2 ON et.cpf_entrevistado2 = ent2.cpf
ORDER BY et.id;

-- seleciona a quantidade de etapas por andamento (CONCLUÍDA/~CONCLUÍDA) e por tipo (Conversação, Narrativa, Entrevista, Vocabulário)

SELECT
    e.codigo AS codigo_entrevista,
    e.fase,
    e.dia AS data_entrevista,
    COUNT(et.id) AS quantidade_etapas,
    COUNT(CASE WHEN et.andamento = 'CONCLUÍDA' THEN 1 END) AS etapas_concluidas,
    COUNT(CASE WHEN et.andamento <> 'CONCLUÍDA' THEN 1 END) AS etapas_andamento
FROM entrevista e
LEFT JOIN etapa et ON e.codigo = et.codigo_entrevista
GROUP BY e.codigo, e.fase, e.dia
ORDER BY e.codigo;

-- seleciona a quantidade de vídeos por tipo e andamento

SELECT
    tipo,
    andamento,
    COUNT(*) AS quantidade_videos
FROM etapa
GROUP BY tipo, andamento
ORDER BY tipo, andamento;

-- seleciona informações sobre os vídeos das etapas

SELECT
    e.codigo as codigo_entrevista,
    et.tipo,
    et.id as id_etapa,
    et.video,
    edita.matricula_bolsista AS matricula_editor,
    anota.matricula_bolsista AS matricula_anotador
FROM entrevista e
LEFT JOIN etapa et ON e.codigo = et.codigo_entrevista
LEFT JOIN edita ON et.id = edita.id_etapa
LEFT JOIN anota ON et.id = anota.id_etapa
ORDER BY e.codigo, et.id;

-- seleciona a quantidade de vídeos por editor e anotador

SELECT
    b.matricula,
    b.pnome,
    COUNT(DISTINCT ed.id_etapa) AS quantidade_videos_editor,
    COUNT(DISTINCT an.id_etapa) AS quantidade_videos_anotador
FROM bolsista b
LEFT JOIN anota an ON b.matricula = an.matricula_bolsista
LEFT JOIN edita ed ON b.matricula = ed.matricula_bolsista
GROUP BY b.matricula, b.pnome
ORDER BY b.pnome;

-- seleciona bolsistas que são tanto editores quanto anotadores

SELECT
    b.matricula,
    b.pnome
FROM bolsista b
WHERE editor = TRUE AND anotador = TRUE
ORDER BY b.pnome;

-- seleciona entrevistas que não têm etapas associadas

SELECT
    codigo AS codigo_entrevista,
    et.id AS id_etapa
FROM entrevista
LEFT JOIN etapa et ON entrevista.codigo = et.codigo_entrevista
WHERE et.id IS NULL
ORDER BY codigo;

-- seleciona etapas que não têm editores ou anotadores associados

SELECT
    et.id AS id_etapa,
    et.video,
    et.tipo,
    ed.matricula_bolsista AS matricula_editor,
    an.matricula_bolsista AS matricula_anotador
FROM etapa et
LEFT JOIN edita ed ON et.id = ed.id_etapa
LEFT JOIN anota an ON et.id = an.id_etapa
WHERE ed.id_etapa IS NULL AND an.id_etapa IS NULL
ORDER BY et.id;


