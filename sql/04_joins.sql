-- ============================================
-- Fase 6 — JOINs
-- Campeonato de futebol
-- ============================================

-- 1. INNER JOIN — só linhas com correspondência nas duas tabelas
SELECT j.nome AS jogador, t.nome AS time
FROM jogadores j
INNER JOIN times t ON t.id = j.time_id;

-- 2. LEFT JOIN — todos os times, mesmo os sem jogadores (jogador = NULL)
SELECT t.nome AS time, j.nome AS jogador
FROM times t
LEFT JOIN jogadores j ON j.time_id = t.id
ORDER BY t.nome;

-- 3. Contagem com LEFT JOIN — COUNT(j.id) ignora NULL; times vazios contam 0
SELECT t.nome AS time, COUNT(j.id) AS qtd_jogadores
FROM times t
LEFT JOIN jogadores j ON j.time_id = t.id
GROUP BY t.nome
ORDER BY qtd_jogadores DESC, time;

-- 4. RIGHT JOIN — espelho do LEFT; garante todas as linhas da direita (times)
SELECT t.nome AS time, j.nome AS jogador
FROM jogadores j
RIGHT JOIN times t ON t.id = j.time_id
ORDER BY t.nome;

-- 5. JOIN em cadeia — súmula das partidas (times entram 2x, com aliases)
SELECT
  p.data_partida,
  casa.nome       AS mandante,
  p.gols_casa,
  p.gols_visitante,
  visit.nome      AS visitante
FROM partidas p
JOIN times casa  ON casa.id  = p.time_casa_id
JOIN times visit ON visit.id = p.time_visitante_id
ORDER BY p.data_partida;

-- 6. SELF JOIN — pares de times fundados no mesmo ano (a.id < b.id evita duplicatas)
SELECT
  a.nome AS time_1,
  b.nome AS time_2,
  EXTRACT(YEAR FROM a.fundacao) AS ano
FROM times a
JOIN times b ON EXTRACT(YEAR FROM a.fundacao) = EXTRACT(YEAR FROM b.fundacao)
            AND a.id < b.id
ORDER BY ano;

-- 7. CROSS JOIN — produto cartesiano; todos os confrontos possíveis (sem mesmo time)
SELECT a.sigla AS mandante, b.sigla AS visitante
FROM times a
CROSS JOIN times b
WHERE a.id <> b.id
LIMIT 10;