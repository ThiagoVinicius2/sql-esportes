# ⚽ SQL Esportes — Campeonato de Futebol

Projeto de estudo completo de **SQL com PostgreSQL**, construído fase a fase sobre um domínio de campeonato de futebol brasileiro. Do zero (modelagem) até análises avançadas (classificação, artilharia, aproveitamento), cobrindo os principais recursos da linguagem.

> Desenvolvido como jornada de aprendizado estruturada, em ambiente reproduzível (GitHub Codespaces + Docker), com cada etapa versionada.

## 📌 Sobre o projeto

O objetivo foi dominar SQL de ponta a ponta usando dados concretos e familiares. Os **estádios e times são reais** (nomes, cidades, capacidades e datas de fundação verificados); jogadores, partidas e gols compõem uma mini-temporada ilustrativa sobre esses clubes reais, montada de forma consistente (a soma dos gols fecha com os placares).

## 🗂️ Modelo de dados

Cinco tabelas normalizadas com integridade referencial garantida por chaves estrangeiras:

```mermaid
erDiagram
  ESTADIOS ||--o{ TIMES : abriga
  ESTADIOS ||--o{ PARTIDAS : sedia
  TIMES ||--o{ JOGADORES : tem
  TIMES ||--o{ PARTIDAS : disputa
  PARTIDAS ||--o{ GOLS : registra
  JOGADORES ||--o{ GOLS : marca
  ESTADIOS {
    int id PK
    varchar nome
    varchar cidade
    int capacidade
  }
  TIMES {
    int id PK
    varchar nome
    char sigla
    date fundacao
    int estadio_id FK
  }
  JOGADORES {
    int id PK
    varchar nome
    varchar posicao
    int numero_camisa
    int time_id FK
  }
  PARTIDAS {
    int id PK
    date data_partida
    int time_casa_id FK
    int time_visitante_id FK
    int estadio_id FK
    int gols_casa
    int gols_visitante
  }
  GOLS {
    int id PK
    int partida_id FK
    int jogador_id FK
    int minuto
    varchar tipo
  }
```

## 🛠️ Stack

- **PostgreSQL 16** — banco de dados
- **Docker Compose** — orquestração do container do Postgres
- **GitHub Codespaces / devcontainer** — ambiente de desenvolvimento reproduzível
- **psql** — cliente de linha de comando

## 🚀 Como executar

O jeito mais simples é via GitHub Codespaces:

1. Clique em **Code → Codespaces → Create codespace on main**. O devcontainer sobe o PostgreSQL automaticamente.
2. No terminal, recrie o banco na ordem:

```bash
psql "$DATABASE_URL" -f sql/01_ddl.sql
psql "$DATABASE_URL" -f sql/02_dml.sql
psql "$DATABASE_URL" -f sql/03_dml_jogadores_partidas.sql
```

> String de conexão: `postgresql://aluno:senha123@localhost:5432/esportes`

Os demais arquivos (`04` a `11`) podem ser executados individualmente para explorar cada tema.

## 📚 Conteúdo por arquivo

| Arquivo | Tema |
|---|---|
| `01_ddl.sql` | Criação de tabelas, tipos, constraints (PK, FK, UNIQUE, CHECK) |
| `02_dml.sql` | Inserção de estádios e times (dados reais) |
| `03_dml_jogadores_partidas.sql` | Inserção de jogadores, partidas e gols |
| `04_joins.sql` | INNER, LEFT, RIGHT, FULL, SELF e CROSS JOIN |
| `05_subqueries_ctes.sql` | Subqueries, CTEs, CTE recursiva |
| `06_window_functions.sql` | ROW_NUMBER, RANK, PARTITION BY, LAG/LEAD, acumulados |
| `07_views.sql` | Views e materialized views |
| `08_indices_performance.sql` | EXPLAIN, ANALYZE, índices |
| `09_transacoes.sql` | BEGIN/COMMIT/ROLLBACK, SAVEPOINT, ACID |
| `10_funcoes_triggers.sql` | Funções (SQL e PL/pgSQL) e triggers |
| `11_projeto_analitico.sql` | Análises finais: classificação, artilharia, aproveitamento |

## 🎯 Conceitos de SQL cobertos

Modelagem e DDL · DML (INSERT/UPDATE/DELETE) · comportamentos de `ON DELETE` (CASCADE, SET NULL, RESTRICT) · SELECT, WHERE, ORDER BY, DISTINCT · operadores e busca de texto (LIKE/ILIKE) · tratamento de NULL · agregações (GROUP BY, HAVING) · todos os tipos de JOIN · subqueries e CTEs · window functions · views e materialized views · índices e leitura de planos de execução · transações e ACID · funções e triggers em PL/pgSQL · análise de dados com SQL.

## 📊 Destaques analíticos

- **Classificação completa** do campeonato (pontos, saldo, ranking) numa única consulta combinando UNION ALL, CASE, CTEs e window function
- **Artilharia** com ranking por DENSE_RANK
- **Aproveitamento (%)** por time
- **Análise de gols** por período do jogo e tipo

## 👤 Autor

**Thiago Vinícius** — [@ThiagoVinicius2](https://github.com/ThiagoVinicius2)