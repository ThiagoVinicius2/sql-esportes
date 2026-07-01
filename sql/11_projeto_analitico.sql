-- ============================================
-- Fase 13 — Projeto analítico final
-- Campeonato de futebol
-- ============================================

-- 1. Classificação completa do campeonato
--    (UNION ALL + CASE + CTEs encadeadas + JOIN + ROW_NUMBER)
WITH resultados AS (
  -- perspectiva do mandante
  SELECT time_casa_id AS time_id, gols_casa AS gp, gols_visitante AS gc,
         CASE WHEN gols_casa > gols_visitante THEN 3
              WHEN gols_casa = gols_visitante THEN 1 ELSE 0 END AS pts
  FROM partidas
  UNION ALL
  -- perspectiva do visitante
  SELECT time_visitante_id, gols_visitante, gols_casa,
         CASE WHEN gols_visitante > gols_casa THEN 3
              WHEN gols_visitante = gols_casa THEN 1 ELSE 0 END
  FROM partidas
),
tabela AS (
  SELECT
    time_id,
    COUNT(*)                                 AS jogos,
    SUM(pts)                                 AS pontos,
    SUM(CASE WHEN pts = 3 THEN 1 ELSE 0 END) AS v,
    SUM(CASE WHEN pts = 1 THEN 1 ELSE 0 END) AS e,
    SUM(CASE WHEN pts = 0 THEN 1 ELSE 0 END) AS d,
    SUM(gp)                                  AS gp,
    SUM(gc)                                  AS gc,
    SUM(gp - gc)                             AS saldo
  FROM resultados
  GROUP BY time_id
)
SELECT
  ROW_NUMBER() OVER (ORDER BY pontos DESC, saldo DESC, gp DESC) AS pos,
  t.nome AS time,
  tb.jogos, tb.pontos, tb.v, tb.e, tb.d, tb.gp, tb.gc, tb.saldo
FROM tabela tb
JOIN times t ON t.id = tb.time_id
ORDER BY pos;

-- 2. Artilheiros do campeonato (ranking com DENSE_RANK por empates)
SELECT
  DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS pos,
  j.nome AS artilheiro,
  t.sigla AS time,
  COUNT(*) AS gols
FROM gols g
JOIN jogadores j ON j.id = g.jogador_id
JOIN times t     ON t.id = j.time_id
GROUP BY j.nome, t.sigla
ORDER BY gols DESC, artilheiro;

-- 3. Aproveitamento (%) por time — pontos sobre pontos possíveis
WITH resultados AS (
  SELECT time_casa_id AS time_id,
         CASE WHEN gols_casa > gols_visitante THEN 3
              WHEN gols_casa = gols_visitante THEN 1 ELSE 0 END AS pts
  FROM partidas
  UNION ALL
  SELECT time_visitante_id,
         CASE WHEN gols_visitante > gols_casa THEN 3
              WHEN gols_visitante = gols_casa THEN 1 ELSE 0 END
  FROM partidas
)
SELECT
  t.nome AS time,
  COUNT(*) AS jogos,
  SUM(pts) AS pontos,
  ROUND(SUM(pts) * 100.0 / (COUNT(*) * 3), 1) AS aproveitamento
FROM resultados r
JOIN times t ON t.id = r.time_id
GROUP BY t.nome
ORDER BY aproveitamento DESC;

-- 4. Análise dos gols: por período do jogo e tipo
SELECT
  CASE WHEN minuto <= 45 THEN '1º tempo' ELSE '2º tempo' END AS periodo,
  tipo,
  COUNT(*) AS gols
FROM gols
GROUP BY periodo, tipo
ORDER BY periodo, gols DESC;

-- 5. Jogos mais movimentados (coluna calculada de total de gols)
SELECT
  p.data_partida,
  casa.sigla  AS mandante,
  p.gols_casa,
  p.gols_visitante,
  visit.sigla AS visitante,
  (p.gols_casa + p.gols_visitante) AS total_gols
FROM partidas p
JOIN times casa  ON casa.id  = p.time_casa_id
JOIN times visit ON visit.id = p.time_visitante_id
ORDER BY total_gols DESC, p.data_partida
LIMIT 5;