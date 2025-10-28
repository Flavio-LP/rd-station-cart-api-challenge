# Desafio Técnico - E-commerce API (Carrinho de Compras)

## 📋 Sobre o Projeto

Este projeto é uma API REST desenvolvida em Ruby on Rails para gerenciamento de carrinho de compras de e-commerce. Foi desenvolvido como parte de um desafio técnico, onde trechos de código já existiam e foram expandidos para implementar as funcionalidades completas do sistema.

## 🚀 Tecnologias e Versões

- **Ruby**: 3.3.1
- **Rails**: 7.1.3.2
- **PostgreSQL**: 16 (Alpine)
- **Redis**: 7.0.15 (Alpine)
- **Sidekiq**: 7.2.4 (processamento de jobs em background)
- **Sidekiq Scheduler**: 5.0.3 (agendamento de jobs)
- **Puma**: Web server
- **RSpec**: 6.1.0 (testes)
- **Rswag**: Documentação Swagger/OpenAPI
- **Factory Bot**: 6.4 (factories para testes)
- **Shoulda Matchers**: 6.0 (matchers para testes)

## 🏗️ Arquitetura

O projeto utiliza:
- **PostgreSQL** como banco de dados relacional
- **Redis** para cache e fila de jobs do Sidekiq
- **Sidekiq** para processamento assíncrono de jobs (gerenciamento de carrinhos abandonados)
- **Docker Compose** para orquestração de containers

## 📦 Dependências para Execução

### Com Docker (Recomendado)

- Docker
- Docker Compose

### Sem Docker

- Ruby 3.3.1
- PostgreSQL 16
- Redis 7.0.15
- Bundler

## 🐳 Executando com Docker Compose

### Serviços Disponíveis

O `docker-compose.yml` configura 4 serviços:

1. **db**: PostgreSQL 16
2. **redis**: Redis 7.0.15
3. **web**: Aplicação Rails (porta 3000)
4. **sidekiq**: Worker para processamento de jobs
5. **test**: Container para execução de testes

### Comandos

--se for sua primeira execução : docker-compose up --build, já nas demais execuções:
  docker-compose up

**Iniciar todos os serviços:**
```bash
docker-compose up

```



📚 Documentação da API
A documentação Swagger é gerada automaticamente através do Rswag e está disponível em:

http://localhost:3000/api-docs

Portas Expostas
3000: Aplicação Rails
5432: PostgreSQL
6379: Redis

🧪 Testes
O projeto utiliza RSpec com:

Testes de integração
Testes de models
Factories com Factory Bot
Matchers com Shoulda Matchers

🎯 Funcionalidades Implementadas
Endpoints da API
POST /cart - Adicionar produto ao carrinho
GET /cart - Listar itens do carrinho atual
POST /cart/add_item - Alterar quantidade de produtos
DELETE /cart/:product_id - Remover produto do carrinho

Jobs Assíncronos
MarkCartAsAbandonedJob: Marca carrinhos sem interação há mais de 3 horas como abandonados
RemoveAbandonedCartsJob: Remove carrinhos abandonados há mais de 7 dias

app/
├── controllers/      # Controllers da API
├── models/          # Models (Cart, CartItem, Product)
├── sidekiq/         # Jobs do Sidekiq
└── views/           # Views (se houver)
config/
├── initializers/    # Configurações (Rswag, Sidekiq)
└── database.yml     # Configuração do banco
spec/
├── integration/     # Testes de integração
└── models/          # Testes de models

📝 Notas Importantes
Este é um projeto de desafio técnico com código base pré-existente
Foram implementadas funcionalidades adicionais conforme especificação
O código segue princípios de Clean Code e legibilidade
Todos os casos de uso descritos no README original estão cobertos
Testes foram adicionados para garantir cobertura das funcionalidades