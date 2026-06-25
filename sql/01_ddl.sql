-- ============================================
-- Fase 2 — DDL: criação das tabelas
-- ============================================

CREATE TABLE estadios (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome        VARCHAR(100) NOT NULL UNIQUE,
    cidade      VARCHAR(80)  NOT NULL,
    capacidade  INT          CHECK (capacidade > 0)
);

CREATE TABLE times (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome        VARCHAR(100) NOT NULL UNIQUE,
    sigla       CHAR(3)      NOT NULL UNIQUE,
    fundacao    DATE,
    estadio_id  INT REFERENCES estadios(id) ON DELETE SET NULL
);

CREATE TABLE jogadores (
    id              INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome            VARCHAR(100) NOT NULL,
    posicao         VARCHAR(20)  CHECK (posicao IN ('Goleiro','Zagueiro','Lateral','Meia','Atacante')),
    data_nascimento DATE,
    numero_camisa   INT          CHECK (numero_camisa BETWEEN 1 AND 99),
    time_id         INT REFERENCES times(id) ON DELETE SET NULL
);

CREATE TABLE partidas (
    id                 INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_partida       DATE NOT NULL,
    time_casa_id       INT  NOT NULL REFERENCES times(id),
    time_visitante_id  INT  NOT NULL REFERENCES times(id),
    estadio_id         INT  REFERENCES estadios(id),
    gols_casa          INT  NOT NULL DEFAULT 0 CHECK (gols_casa >= 0),
    gols_visitante     INT  NOT NULL DEFAULT 0 CHECK (gols_visitante >= 0),
    CONSTRAINT times_diferentes CHECK (time_casa_id <> time_visitante_id)
);

CREATE TABLE gols (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    partida_id  INT NOT NULL REFERENCES partidas(id) ON DELETE CASCADE,
    jogador_id  INT NOT NULL REFERENCES jogadores(id) ON DELETE CASCADE,
    minuto      INT CHECK (minuto BETWEEN 1 AND 130),
    tipo        VARCHAR(10) NOT NULL DEFAULT 'normal'
                CHECK (tipo IN ('normal','penalti','contra'))
);