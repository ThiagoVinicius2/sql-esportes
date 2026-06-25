-- ============================================
-- Fase 3 — DML: inserção de dados (reais)
-- ============================================

-- Estádios (14 arenas reais; Maracanã é compartilhado por Fla e Flu)
INSERT INTO estadios (nome, cidade, capacidade) VALUES
('Maracanã',           'Rio de Janeiro',  78838),
('Allianz Parque',     'São Paulo',       43713),
('Neo Química Arena',  'São Paulo',       49205),
('MorumBis',           'São Paulo',       66795),
('Arena do Grêmio',    'Porto Alegre',    55662),
('Beira-Rio',          'Porto Alegre',    50842),
('Arena MRV',          'Belo Horizonte',  46000),
('Mineirão',           'Belo Horizonte',  62000),
('Nilton Santos',      'Rio de Janeiro',  44661),
('São Januário',       'Rio de Janeiro',  22000),
('Ligga Arena',        'Curitiba',        42000),
('Couto Pereira',      'Curitiba',        40000),
('Arena Fonte Nova',   'Salvador',        48000),
('Arena Castelão',     'Fortaleza',       63903);

-- Times (15 clubes reais; estadio_id buscado pelo nome do estádio)
INSERT INTO times (nome, sigla, fundacao, estadio_id) VALUES
('Flamengo',      'FLA', '1895-11-15', (SELECT id FROM estadios WHERE nome='Maracanã')),
('Fluminense',    'FLU', '1902-07-21', (SELECT id FROM estadios WHERE nome='Maracanã')),
('Palmeiras',     'PAL', '1914-08-26', (SELECT id FROM estadios WHERE nome='Allianz Parque')),
('Corinthians',   'COR', '1910-09-01', (SELECT id FROM estadios WHERE nome='Neo Química Arena')),
('São Paulo',     'SAO', '1930-01-25', (SELECT id FROM estadios WHERE nome='MorumBis')),
('Grêmio',        'GRE', '1903-09-15', (SELECT id FROM estadios WHERE nome='Arena do Grêmio')),
('Internacional', 'INT', '1909-04-04', (SELECT id FROM estadios WHERE nome='Beira-Rio')),
('Atlético-MG',   'CAM', '1908-03-25', (SELECT id FROM estadios WHERE nome='Arena MRV')),
('Cruzeiro',      'CRU', '1921-01-02', (SELECT id FROM estadios WHERE nome='Mineirão')),
('Botafogo',      'BOT', '1904-08-12', (SELECT id FROM estadios WHERE nome='Nilton Santos')),
('Vasco',         'VAS', '1898-08-21', (SELECT id FROM estadios WHERE nome='São Januário')),
('Athletico-PR',  'CAP', '1924-03-26', (SELECT id FROM estadios WHERE nome='Ligga Arena')),
('Coritiba',      'CFC', '1909-06-12', (SELECT id FROM estadios WHERE nome='Couto Pereira')),
('Bahia',         'BAH', '1931-01-01', (SELECT id FROM estadios WHERE nome='Arena Fonte Nova')),
('Fortaleza',     'FOR', '1918-10-18', (SELECT id FROM estadios WHERE nome='Arena Castelão'));