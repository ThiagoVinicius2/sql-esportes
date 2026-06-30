-- ============================================
-- Fase 11 — Transações
-- Campeonato de futebol
-- ============================================

-- 1. Ciclo básico — BEGIN abre, COMMIT confirma (esta mudança PERSISTE)
BEGIN;
UPDATE estadios SET capacidade = capacidade + 1000 WHERE nome = 'Maracanã';
SELECT nome, capacidade FROM estadios WHERE nome = 'Maracanã';
COMMIT;

-- 2. Atomicidade — dois comandos como unidade; ROLLBACK desfaz ambos
BEGIN;
INSERT INTO estadios (nome, cidade, capacidade) VALUES ('Estádio Teste', 'Curitiba', 30000);
UPDATE times SET estadio_id = (SELECT id FROM estadios WHERE nome = 'Estádio Teste')
WHERE sigla = 'CFC';
SELECT t.nome, e.nome AS estadio
FROM times t JOIN estadios e ON e.id = t.estadio_id
WHERE t.sigla = 'CFC';
ROLLBACK;

-- 3. SAVEPOINT — desfaz parcial (mantém Arena A, descarta Arena B)
BEGIN;
INSERT INTO estadios (nome, cidade, capacidade) VALUES ('Arena A', 'Recife', 25000);
SAVEPOINT ponto1;
INSERT INTO estadios (nome, cidade, capacidade) VALUES ('Arena B', 'Natal', 20000);
ROLLBACK TO ponto1;
SELECT nome FROM estadios WHERE nome IN ('Arena A', 'Arena B');
ROLLBACK;

-- 4. Ver o nível de isolamento atual (padrão: read committed)
SHOW transaction_isolation;

-- 5. Transação envenenada — erro aborta tudo até o ROLLBACK
BEGIN;
INSERT INTO estadios (nome, cidade, capacidade) VALUES ('Arena C', 'Belém', 28000);
INSERT INTO estadios (nome, cidade, capacidade) VALUES ('Maracanã', 'Rio', 50000);  -- erro: duplicado
SELECT 1;  -- também falha: current transaction is aborted
ROLLBACK;

-- ACID: Atomicidade (tudo ou nada), Consistência (respeita constraints),
--       Isolamento (transações concorrentes), Durabilidade (sobrevive a falhas)