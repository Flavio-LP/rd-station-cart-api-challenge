# E-commerce API (Carrinho de Compras)

## 📋 Sobre o Projeto

API REST em Ruby on Rails para gerenciamento de carrinho de compras de e-commerce. Desenvolvida como parte de um desafio técnico, expandindo um código base pré-existente para entregar as funcionalidades completas do sistema.

OBS: Projeto construído para uso com docker-compose.

---

## 🚀 Tecnologias e Versões

* **Ruby**: 3.3.1

* **Rails**: 7.1.3.2

* **PostgreSQL**: 16 (Alpine)

* **Redis**: 7.0.15 (Alpine)

* **Sidekiq**: 7.2.4 (processamento de jobs em background)

* **Sidekiq Scheduler**: 5.0.3 (agendamento de jobs)

* **Puma**: Web server

* **RSpec**: 6.1.0 (testes)

* **Rswag**: Documentação Swagger/OpenAPI

* **Factory Bot**: 6.4 (factories para testes)

* **Shoulda Matchers**: 6.0 (matchers para testes)

---

## 🏗️ Arquitetura

O projeto utiliza:

* **PostgreSQL** como banco de dados relacional

* **Redis** para cache e filas do Sidekiq

* **Sidekiq** para processamento assíncrono (carrinhos abandonados)

* **Docker Compose** para orquestração de containers

---

## 📦 Dependências para Execução

### Com Docker (Recomendado)

* Docker

* Docker Compose

### Sem Docker

* Ruby 3.3.1

* PostgreSQL 16

* Redis 7.0.15

* Bundler

---

## 🐳 Executando com Docker Compose

### Serviços Disponíveis

O `docker-compose.yml` configura os seguintes serviços:

1. **db**: PostgreSQL 16

2. **redis**: Redis 7.0.15

3. **web**: Aplicação Rails (porta 3000)

4. **sidekiq**: Worker para jobs

5. **test**: Container para execução de testes

### Comandos

**Primeira execução (build das imagens):**

```bash
docker-compose up --build
```

**Demais execuções:**

```bash
docker-compose up
```

**Parar e remover containers:**

```bash
docker-compose down
```

**Executar migrações (se necessário):**

```bash
docker-compose run --rm web bin/rails db:create db:migrate
```

---

## 🌐 Documentação da API (Swagger)

A documentação é gerada automaticamente pelo Rswag e está disponível em:

**[http://localhost:3000/api-docs](http://localhost:3000/api-docs)**

---

## 🔌 Portas Expostas

* **3000**: Aplicação Rails

* **5432**: PostgreSQL

* **6379**: Redis

---

## 🧪 Testes

O projeto utiliza RSpec com:

* Testes de integração

* Testes de models

* Factories com Factory Bot

* Matchers com Shoulda Matchers

### Comandos de Teste

```bash
# Rodar a suíte completa
bundle exec rspec

# Rodar testes com documentação
bundle exec rspec --format documentation
```

### Lista de Tópicos dos Testes

#### Factories (Fábricas de Dados de Teste)

**spec/factories/cart_items.rb**

* Criação de itens de carrinho com associações de carrinho e produto

* Trait para múltiplas quantidades

* Trait para produtos caros

* Trait para produtos baratos

**spec/factories/carts.rb**

* Criação de carrinhos com preço total zerado

* Trait para carrinho com múltiplos itens

* Trait para carrinho abandonado

* Trait para carrinho não abandonado

**spec/factories/products.rb**

* Criação de produtos com nome e preço sequenciais

* Trait para produtos caros

* Trait para produtos baratos

#### Testes de Modelo

**spec/models/cart_spec.rb**

* Validação de numericalidade do preço total (não pode ser negativo)

* Marcação de carrinho como abandonado após inatividade

* Remoção de carrinho se abandonado por tempo determinado

**spec/models/product_spec.rb**

* Validação de presença do nome

* Validação de presença do preço

* Validação de numericalidade do preço (não pode ser negativo)

#### Testes de Requisição (Request)

**spec/requests/carts_spec.rb**

* Atualização de quantidade quando produto já existe no carrinho

* Adição de novo produto ao carrinho

* Criação de novo carrinho quando não existe

* Retorno de erro quando produto não existe

* Retorno de erro de validação quando quantidade é zero

**spec/requests/products_spec.rb**

* Listagem de produtos com sucesso

* Exibição de produto específico com sucesso

* Criação de produto com parâmetros válidos

* Retorno de erro ao criar produto com parâmetros inválidos

* Atualização de produto com parâmetros válidos

* Retorno de erro ao atualizar produto com parâmetros inválidos

* Exclusão de produto com sucesso

#### Testes de Integração (API)

**spec/integration/carts_spec.rb**

* Criação de carrinho e adição de produto via POST /cart

* Exibição do carrinho atual via GET /cart

* Adição de item ao carrinho via POST /cart/add_item

* Remoção de item do carrinho via DELETE /cart/{product_id}

* Retorno de erro 404 quando produto não está no carrinho

#### Testes de Roteamento

**spec/routing/carts_routing_spec.rb**

* Rota GET /cart para exibição do carrinho

* Rota POST /cart para criação do carrinho

* Rota POST /cart/add_item para adicionar item

* Rota DELETE /cart/{product_id} para remover item

* Geração correta de paths para as ações

**spec/routing/products_routing_spec.rb**

* Rota GET /products para listagem

* Rota GET /products/:id para exibição

* Rota POST /products para criação

* Rota PUT /products/:id para atualização

* Rota PATCH /products/:id para atualização

* Rota DELETE /products/:id para exclusão

#### Testes de Jobs (Sidekiq)

**spec/sidekiq/mark_cart_as_abandoned_job_spec.rb**

* Marcação de carrinhos inativos como abandonados

* Não marcação de carrinhos ativos como abandonados

* Não alteração de carrinhos já abandonados

* Marcação de carrinhos inativos por mais de 3 horas

* Log do número de carrinhos marcados como abandonados

* Verificação da fila padrão do job

* Enfileiramento do job

* Marcação de múltiplos carrinhos inativos

* Marcação de carrinhos exatamente no limite de 3 horas

* Marcação de carrinhos com itens como abandonados

* Não remoção de itens ao marcar carrinho como abandonado

**spec/sidekiq/remove_abandoned_carts_job_spec.rb**

* Remoção de carrinhos abandonados antigos (mais de 7 dias)

* Manutenção de carrinhos abandonados recentes

* Manutenção de carrinhos ativos

* Verificação da fila padrão do job

* Enfileiramento do job

* Remoção de carrinho e itens associados

#### Arquivos de Suporte

**spec/support/factory_bot.rb**

* Configuração do FactoryBot para uso nos testes

**spec/support/sidekiq.rb**

* Limpeza de workers do Sidekiq antes de cada teste

* Configuração para execução inline do Sidekiq

* Configuração para execução fake do Sidekiq

---

## 🎯 Funcionalidades Implementadas

### Endpoints da API

#### **POST /cart** — Adicionar produto ao carrinho

_Payload:_

```json
{
  "product_id": 345,
  "quantity": 2
}
```

_Response:_

```json
{
  "id": 789,
  "products": [
    {
      "id": 345,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    }
  ],
  "total_price": 7.96
}
```

#### **GET /cart** — Listar itens do carrinho atual

_Response:_

```json
{
  "id": 789,
  "products": [
    {
      "id": 345,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    }
  ],
  "total_price": 7.96
}
```

#### **POST /cart/add_item** — Alterar quantidade de produtos

_Payload:_

```json
{
  "product_id": 100,
  "quantity": 2
}
```

_Response:_

```json
{
  "id": 789,
  "products": [
    {
      "id": 100,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    },
    {
      "id": 345,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    }
  ],
  "total_price": 11.94
}
```

#### **DELETE /cart/:product_id** — Remover produto do carrinho

_Response:_

```json
{
  "id": 789,
  "products": [
    {
      "id": 645,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    }
  ],
  "total_price": 7.96
}
```

Consulte exemplos de requisições, corpos e respostas no Swagger em `/api-docs`.

### Jobs Assíncronos

* **MarkCartAsAbandonedJob**: marca carrinhos sem interação há mais de 3 horas como abandonados

* **RemoveAbandonedCartsJob**: remove carrinhos abandonados há mais de 7 dias

---



## ⚙️ Configuração (Sem Docker)

### 1\. Instalar dependências:

```bash
bundle install
```

### 2\. Configurar banco:

```bash
bin/rails db:create db:migrate
```

### 3\. Subir servidor:

```bash
bin/rails server
```

### 4\. Subir Sidekiq:

```bash
bundle exec sidekiq
```

**Nota**: Certifique-se de que `Redis` e `PostgreSQL` estejam em execução e que as variáveis de ambiente (como `DATABASE_URL` e `REDIS_URL`, se aplicável) estejam configuradas.

---

## 📝 Notas Importantes

* Projeto desenvolvido para um desafio técnico com código base pré-existente

* Funcionalidades adicionais foram implementadas conforme especificação

* Código segue princípios de Clean Code e legibilidade

* Casos de uso do README original estão cobertos

* Testes adicionados para garantir cobertura das funcionalidades

---

## 📄 Escopo do Desafio Técnico

# Desafio técnico e-commerce

## Nossas expectativas

A equipe de engenharia da RD Station tem alguns princípios nos quais baseamos nosso trabalho diário. Um deles é: projete seu código para ser mais fácil de entender, não mais fácil de escrever.

Portanto, para nós, é mais importante um código de fácil leitura do que um que utilize recursos complexos e/ou desnecessários.

O que gostaríamos de ver:

- O código deve ser fácil de ler. Clean Code pode te ajudar.
- Notas gerais e informações sobre a versão da linguagem e outras informações importantes para executar seu código.
- Código que se preocupa com a performance (complexidade de algoritmo).
- O seu código deve cobrir todos os casos de uso presentes no README, mesmo que não haja um teste implementado para tal.
- A adição de novos testes é sempre bem-vinda.
- Você deve enviar para nós o link do repositório público com a aplicação desenvolvida (GitHub, BitBucket, etc.).

## O Desafio - Carrinho de compras
O desafio consiste em uma API para gerenciamento do um carrinho de compras de e-commerce.

Você deve desenvolver utilizando a linguagem Ruby e framework Rails, uma API Rest que terá 3 endpoins que deverão implementar as seguintes funcionalidades:

### 1. Registrar um produto no carrinho
Criar um endpoint para inserção de produtos no carrinho.

Se não existir um carrinho para a sessão, criar o carrinho e salvar o ID do carrinho na sessão.

Adicionar o produto no carrinho e devolver o payload com a lista de produtos do carrinho atual.


ROTA: `/cart`
Payload:
```js
{
  "product_id": 345, // id do produto sendo adicionado
  "quantity": 2, // quantidade de produto a ser adicionado
}
```

Response
```js
{
  "id": 789, // id do carrinho
  "products": [
    {
      "id": 645,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99, // valor unitário do produto
      "total_price": 3.98, // valor total do produto
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98,
    },
  ],
  "total_price": 7.96 // valor total no carrinho
}
```

### 2. Listar itens do carrinho atual
Criar um endpoint para listar os produtos no carrinho atual.

ROTA: `/cart`

Response:
```js
{
  "id": 789, // id do carrinho
  "products": [
    {
      "id": 645,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99, // valor unitário do produto
      "total_price": 3.98, // valor total do produto
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98,
    },
  ],
  "total_price": 7.96 // valor total no carrinho
}
```

### 3. Alterar a quantidade de produtos no carrinho 
Um carrinho pode ter _N_ produtos, se o produto já existir no carrinho, apenas a quantidade dele deve ser alterada

ROTA: `/cart/add_item`

Payload
```json
{
  "product_id": 1230,
  "quantity": 1
}
```
Response:
```json
{
  "id": 1,
  "products": [
    {
      "id": 1230,
      "name": "Nome do produto X",
      "quantity": 2, // considerando que esse produto já estava no carrinho
      "unit_price": 7.00, 
      "total_price": 14.00, 
    },
    {
      "id": 01020,
      "name": "Nome do produto Y",
      "quantity": 1,
      "unit_price": 9.90, 
      "total_price": 9.90, 
    },
  ],
  "total_price": 23.9
}
```

### 3. Remover um produto do carrinho 

Criar um endpoint para excluir um produto do do carrinho. 

ROTA: `/cart/:product_id`


#### Detalhes adicionais:

- Verifique se o produto existe no carrinho antes de tentar removê-lo.
- Se o produto não estiver no carrinho, retorne uma mensagem de erro apropriada.
- Após remover o produto, retorne o payload com a lista atualizada de produtos no carrinho.
- Certifique-se de que o endpoint lida corretamente com casos em que o carrinho está vazio após a remoção do produto.

### 5. Excluir carrinhos abandonados
Um carrinho é considerado abandonado quando estiver sem interação (adição ou remoção de produtos) há mais de 3 horas.

- Quando este cenário ocorrer, o carrinho deve ser marcado como abandonado.
- Se o carrinho estiver abandonado há mais de 7 dias, remover o carrinho.
- Utilize um Job para gerenciar (marcar como abandonado e remover) carrinhos sem interação.
- Configure a aplicação para executar este Job nos períodos especificados acima.

### Detalhes adicionais:
- O Job deve ser executado regularmente para verificar e marcar carrinhos como abandonados após 3 horas de inatividade.
- O Job também deve verificar periodicamente e excluir carrinhos que foram marcados como abandonados por mais de 7 dias.

### Como resolver

#### Implementação
Você deve usar como base o código disponível nesse repositório e expandi-lo para que atenda as funcionalidade descritas acima.

Há trechos parcialmente implementados e também sugestões de locais para algumas das funcionalidades sinalizados com um `# TODO`. Você pode segui-los ou fazer da maneira que julgar ser a melhor a ser feita, desde que atenda os contratos de API e funcionalidades descritas.

#### Testes
Existem testes pendentes, eles estão marcados como <span style="color:green;">Pending</span>, e devem ser implementados para garantir a cobertura dos trechos de código implementados por você.
Alguns testes já estão passando e outros estão com erro. Com a sua implementação os testes com erro devem passar a funcionar. 
A adição de novos testes é sempre bem-vinda, mas sem alterar os já implementados.


### O que esperamos
- Implementação dos testes faltantes e de novos testes para os métodos/serviços/entidades criados
- Construção das 4 rotas solicitadas
- Implementação de um job para controle dos carrinhos abandonados


### Itens adicionais / Legais de ter
- Utilização de factory na construção dos testes
- Desenvolvimento do docker-compose / dockerização da app

A aplicação já possui um Dockerfile, que define como a aplicação deve ser configurada dentro de um contêiner Docker. No entanto, para completar a dockerização da aplicação, é necessário criar um arquivo `docker-compose.yml`. O arquivo irá definir como os vários serviços da aplicação (por exemplo, aplicação web, banco de dados, etc.) interagem e se comunicam.

- Adicione tratamento de erros para situações excepcionais válidas, por exemplo: garantir que um produto não possa ter quantidade negativa. 

- Se desejar você pode adicionar a configuração faltante no arquivo `docker-compose.yml` e garantir que a aplicação rode de forma correta utilizando Docker. 

## Informações técnicas

### Dependências
- ruby 3.3.1
- rails 7.1.3.2
- postgres 16
- redis 7.0.15

### Como executar o projeto

## Executando a app sem o docker
Dado que todas as as ferramentas estão instaladas e configuradas:

Instalar as dependências do:
```bash
bundle install
```

Executar o sidekiq:
```bash
bundle exec sidekiq
```

Executar projeto:
```bash
bundle exec rails server
```

Executar os testes:
```bash
bundle exec rspec
```

### Como enviar seu projeto
Salve seu código em um versionador de código (GitHub, GitLab, Bitbucket) e nos envie o link publico. Se achar necessário, informe no README as instruções para execução ou qualquer outra informação relevante para correção/entendimento da sua solução.

## 📄 Licença

Este projeto é parte de um desafio técnico. Caso necessário, adicione aqui a licença aplicável (por exemplo, MIT) ou restrições de uso.