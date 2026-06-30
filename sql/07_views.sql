-- ============================================
-- Fase 9 — Views
-- Campeonato de futebol
-- ============================================

-- 1. View simples — tabela de artilheiros (esconde 3 JOINs + GROUP BY)
CREATE VIEW vw_artilheiros AS
SELECT j.nome AS jogador, t.sigla AS time, COUNT(*) AS gols
FROM gols g
JOIN jogadores j ON j.id = g.jogador_id
JOIN times t     ON t.id = j.time_id
GROUP BY j.nome, t.sigla;

-- 2. Usar a view como se fosse uma tabela
SELECT * FROM vw_artilheiros ORDER BY gols DESC LIMIT 5;

-- 3. Compor a view com filtros adicionais
SELECT * FROM vw_artilheiros WHERE gols >= 3 ORDER BY gols DESC;

-- 4. View elaborada — desempenho como mandante (usa CASE WHEN)
CREATE VIEW vw_desempenho_casa AS
SELECT
  t.sigla,
  COUNT(*) AS jogos_casa,
  SUM(CASE WHEN p.gols_casa > p.gols_visitante THEN 1 ELSE 0 END) AS vitorias,
  SUM(CASE WHEN p.gols_casa = p.gols_visitante THEN 1 ELSE 0 END) AS empates,
  SUM(CASE WHEN p.gols_casa < p.gols_visitante THEN 1 ELSE 0 END) AS derrotas
FROM partidas p
JOIN times t ON t.id = p.time_casa_id
GROUP BY t.sigla;

SELECT * FROM vw_desempenho_casa ORDER BY vitorias DESC;

-- 5. Materialized view — guarda o resultado em disco (precisa de REFRESH)
CREATE MATERIALIZED VIEW mvw_artilheiros AS
SELECT j.nome AS jogador, t.sigla AS time, COUNT(*) AS gols
FROM gols g
JOIN jogadores j ON j.id = g.jogador_id
JOIN times t     ON t.id = j.time_id
GROUP BY j.nome, t.sigla;

SELECT * FROM mvw_artilheiros ORDER BY gols DESC LIMIT 5;

-- Atualizar a materialized view após mudanças nos dados:
REFRESH MATERIALIZED VIEW mvw_artilheiros;

-- 6. Gestão (referência):
-- \dv   lista views   |   \dm   lista materialized views
-- DROP VIEW vw_desempenho_casa;
-- DROP MATERIALIZED VIEW mvw_artilheiros;