-- ============================================
-- Fase 10 — Índices e performance
-- Campeonato de futebol
-- ============================================

-- 1. EXPLAIN — mostra o plano de execução sem rodar a consulta
EXPLAIN SELECT * FROM jogadores WHERE nome = 'Hulk';

-- 2. EXPLAIN ANALYZE — executa de verdade e mede tempos reais
EXPLAIN ANALYZE SELECT * FROM jogadores WHERE nome = 'Hulk';

-- 3. Criar índice sobre a coluna nome
CREATE INDEX idx_jogadores_nome ON jogadores(nome);

-- 4. Rodar de novo — em tabela pequena, o otimizador ainda prefere Seq Scan
EXPLAIN SELECT * FROM jogadores WHERE nome = 'Hulk';

-- 5. Índices em chaves estrangeiras (o uso mais valioso — aceleram JOINs)
EXPLAIN ANALYZE
SELECT j.nome, COUNT(*)
FROM gols g
JOIN jogadores j ON j.id = g.jogador_id
GROUP BY j.nome;

CREATE INDEX idx_gols_jogador_id ON gols(jogador_id);
CREATE INDEX idx_gols_partida_id ON gols(partida_id);

-- 6. Inspecionar índices:
-- \d jogadores   (seção Indexes)   |   \di   lista todos os índices