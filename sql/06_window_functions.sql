-- ============================================
-- Fase 8 — Window functions
-- Campeonato de futebol
-- ============================================

-- 1. OVER() vazio — média geral repetida em cada linha (não colapsa)
SELECT
  nome,
  capacidade,
  ROUND(AVG(capacidade) OVER ()) AS media_geral,
  capacidade - ROUND(AVG(capacidade) OVER ()) AS diferenca
FROM estadios
ORDER BY capacidade DESC;

-- 2. ROW_NUMBER — numera as linhas na ordem da janela
SELECT
  ROW_NUMBER() OVER (ORDER BY capacidade DESC) AS posicao,
  nome,
  capacidade
FROM estadios;

-- 3. RANK vs DENSE_RANK vs ROW_NUMBER — tratamento de empates lado a lado
WITH artilheiros AS (
  SELECT j.nome, t.sigla, COUNT(*) AS gols
  FROM gols g
  JOIN jogadores j ON j.id = g.jogador_id
  JOIN times t     ON t.id = j.time_id
  GROUP BY j.nome, t.sigla
)
SELECT
  RANK()       OVER (ORDER BY gols DESC) AS rank,
  DENSE_RANK() OVER (ORDER BY gols DESC) AS dense_rank,
  ROW_NUMBER() OVER (ORDER BY gols DESC) AS row_number,
  nome, sigla, gols
FROM artilheiros;

-- 4. PARTITION BY — ranking de artilheiros reiniciado por time
WITH gols_jogador AS (
  SELECT j.nome, j.time_id, COUNT(*) AS gols
  FROM gols g
  JOIN jogadores j ON j.id = g.jogador_id
  GROUP BY j.nome, j.time_id
)
SELECT
  t.sigla,
  gj.nome,
  gj.gols,
  RANK() OVER (PARTITION BY gj.time_id ORDER BY gj.gols DESC) AS rank_no_time
FROM gols_jogador gj
JOIN times t ON t.id = gj.time_id
ORDER BY t.sigla, rank_no_time;

-- 5. COUNT acumulado — total de gols correndo na ordem do minuto
SELECT
  g.minuto,
  j.nome,
  COUNT(*) OVER (ORDER BY g.minuto) AS gols_ate_aqui
FROM gols g
JOIN jogadores j ON j.id = g.jogador_id
ORDER BY g.minuto;

-- 6. LAG — comparar com a linha anterior (intervalo entre gols)
SELECT
  g.minuto,
  j.nome,
  LAG(g.minuto)  OVER (ORDER BY g.minuto) AS minuto_anterior,
  g.minuto - LAG(g.minuto) OVER (ORDER BY g.minuto) AS intervalo
FROM gols g
JOIN jogadores j ON j.id = g.jogador_id
ORDER BY g.minuto;