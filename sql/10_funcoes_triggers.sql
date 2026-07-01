-- ============================================
-- Fase 12 — Funções e triggers
-- Campeonato de futebol
-- ============================================

-- 1. Função simples (linguagem SQL) — conta gols de um jogador
CREATE FUNCTION total_gols_jogador(p_jogador_id INT)
RETURNS BIGINT
LANGUAGE sql
AS $$
  SELECT COUNT(*) FROM gols WHERE jogador_id = p_jogador_id;
$$;

SELECT nome, total_gols_jogador(id) AS gols
FROM jogadores
ORDER BY gols DESC
LIMIT 5;

-- 2. Função PL/pgSQL com lógica (IF/ELSIF/ELSE) — classifica porte do estádio
CREATE FUNCTION classifica_estadio(p_capacidade INT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN
  IF p_capacidade >= 60000 THEN
    RETURN 'Grande';
  ELSIF p_capacidade >= 45000 THEN
    RETURN 'Médio';
  ELSE
    RETURN 'Pequeno';
  END IF;
END;
$$;

SELECT nome, capacidade, classifica_estadio(capacidade) AS porte
FROM estadios
ORDER BY capacidade DESC;

-- 3. Função que retorna tabela — artilheiros de um time (parametrizada)
CREATE FUNCTION artilheiros_do_time(p_sigla TEXT)
RETURNS TABLE(jogador VARCHAR, gols BIGINT)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT j.nome, COUNT(*)
    FROM gols g
    JOIN jogadores j ON j.id = g.jogador_id
    JOIN times t     ON t.id = j.time_id
    WHERE t.sigla = p_sigla
    GROUP BY j.nome
    ORDER BY COUNT(*) DESC;
END;
$$;

SELECT * FROM artilheiros_do_time('CAM');
SELECT * FROM artilheiros_do_time('INT');

-- 4. Tabela de log (auditoria) para o trigger
CREATE TABLE log_gols (
  id            INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  gol_id        INT,
  jogador_id    INT,
  registrado_em TIMESTAMP DEFAULT now()
);

-- 5. Função do trigger — usa NEW (a linha sendo inserida)
CREATE FUNCTION registra_log_gol()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO log_gols (gol_id, jogador_id)
  VALUES (NEW.id, NEW.jogador_id);
  RETURN NEW;
END;
$$;

-- 6. O trigger — dispara AFTER INSERT, uma vez por linha
CREATE TRIGGER trg_log_gol
AFTER INSERT ON gols
FOR EACH ROW
EXECUTE FUNCTION registra_log_gol();

-- Teste (dentro de transação para não persistir): o log é gravado sozinho
BEGIN;
INSERT INTO gols (partida_id, jogador_id, minuto, tipo)
VALUES (1, 1, 15, 'normal');
SELECT * FROM log_gols;
ROLLBACK;

-- 7. Gestão (referência):
-- \df   lista funções   |   \d gols   mostra triggers da tabela
-- DROP TRIGGER trg_log_gol ON gols;
-- DROP FUNCTION registra_log_gol();