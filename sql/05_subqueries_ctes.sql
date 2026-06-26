-- ============================================
-- Fase 7 — Subqueries e CTEs
-- Campeonato de futebol
-- ============================================

-- 1. Subquery escalar — estádios acima da capacidade média
SELECT ROUND(AVG(capacidade)) AS media_geral FROM estadios;

SELECT nome, capacidade
FROM estadios
WHERE capacidade > (SELECT AVG(capacidade) FROM estadios)
ORDER BY capacidade DESC;

-- 2. Subquery com IN — jogadores que marcaram pelo menos um gol
SELECT nome, posicao
FROM jogadores
WHERE id IN (SELECT DISTINCT jogador_id FROM gols)
ORDER BY nome;

-- 3. NOT IN — jogadores que não marcaram nenhum gol
SELECT nome, posicao
FROM jogadores
WHERE id NOT IN (SELECT jogador_id FROM gols)
ORDER BY posicao, nome;

-- 4. Subquery correlacionada — total de gols de cada jogador (roda por linha)
SELECT
  j.nome,
  (SELECT COUNT(*) FROM gols g WHERE g.jogador_id = j.id) AS gols
FROM jogadores j
WHERE (SELECT COUNT(*) FROM gols g WHERE g.jogador_id = j.id) > 0
ORDER BY gols DESC;

-- 5. CTE — gols por jogador organizados com WITH
WITH gols_por_jogador AS (
  SELECT jogador_id, COUNT(*) AS total
  FROM gols
  GROUP BY jogador_id
)
SELECT j.nome, t.sigla, gpj.total AS gols
FROM gols_por_jogador gpj
JOIN jogadores j ON j.id = gpj.jogador_id
JOIN times t     ON t.id = j.time_id
ORDER BY gols DESC;

-- 6. CTEs encadeadas — gols por jogador, depois somados por time
WITH gols_por_jogador AS (
  SELECT jogador_id, COUNT(*) AS total
  FROM gols
  GROUP BY jogador_id
),
gols_por_time AS (
  SELECT j.time_id, SUM(gpj.total) AS gols_time
  FROM gols_por_jogador gpj
  JOIN jogadores j ON j.id = gpj.jogador_id
  GROUP BY j.time_id
)
SELECT t.nome AS time, gpt.gols_time
FROM gols_por_time gpt
JOIN times t ON t.id = gpt.time_id
ORDER BY gpt.gols_time DESC;

-- 7. CTE recursiva — gera a sequência de 1 a 10
WITH RECURSIVE contagem AS (
  SELECT 1 AS n                           -- caso base
  UNION ALL
  SELECT n + 1 FROM contagem WHERE n < 10  -- passo recursivo
)
SELECT n FROM contagem;