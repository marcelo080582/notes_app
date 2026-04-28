# 📝 Sistema de Anotações

Aplicação fullstack desenvolvida como teste técnico.

Permite criar, listar, editar, excluir e buscar anotações, com foco em boas práticas, organização de código, testes, experiência do usuário e facilidade de execução com Docker.

---

## 🚀 Tecnologias utilizadas

### Backend
- Ruby on Rails (API mode)
- PostgreSQL
- RSpec
- FactoryBot
- Kaminari (paginação)
- JWT (autenticação)

### Frontend
- Vue 3
- Vite
- Axios
- Vitest + Vue Test Utils

### Infra
- Docker
- Docker Compose

---

## 📦 Funcionalidades

### 🔐 Autenticação
- Cadastro de usuário
- Login com JWT
- Proteção de rotas
- Cada usuário acessa apenas suas próprias notas

### 📝 Notas
- Criar anotação
- Listar anotações com paginação (5 por página)
- Editar anotação
- Excluir anotação
- Buscar por título e conteúdo
- Busca com suporte a acentos (`unaccent`)

### 🎯 UX
- Loading states
- Feedback de erro e sucesso
- Debounce na busca
- Contador de caracteres
- Layout responsivo

---

## ⚙️ Como rodar o projeto

## 🔹 Opção 1: Rodar com Docker

### Pré-requisitos

- Docker instalado
- Docker Compose instalado

### Subir o projeto

```bash
docker compose up --build
```

### Criar e migrar o banco

Em outro terminal ou aba:

```bash
docker compose exec backend rails db:create db:migrate
```

### Acessos

```text
Frontend: http://localhost:5173
Backend:  http://localhost:3000
```

### Parar os containers

```bash
docker compose down
```

---

## 🔹 Opção 2: Rodar manualmente

### Backend (Rails)

#### Pré-requisitos

- Ruby instalado
- PostgreSQL instalado

#### Passos

```bash
bundle install
rails db:create
rails db:migrate
rails s
```

Backend disponível em:

```text
http://localhost:3000
```

---

### Frontend (Vue)

#### Pré-requisitos

- Node.js instalado

#### Passos

```bash
cd frontend
npm install
npm run dev
```

Frontend disponível em:

```text
http://localhost:5173
```

---

## 🧪 Rodando testes

### Backend sem Docker

```bash
bundle exec rspec
```

### Backend com Docker

```bash
docker compose exec backend bundle exec rspec
```

### Frontend sem Docker

```bash
cd frontend
npm run test
```

### Frontend com Docker

```bash
docker compose exec frontend npm run test
```

---

## 🔐 Autenticação

A API utiliza JWT.

Resposta após login/cadastro:

```json
{
  "token": "jwt_token",
  "user": { ... }
}
```

Header enviado pelo frontend:

```text
Authorization: Bearer <token>
```

Regras:
- Rotas protegidas
- Usuário acessa apenas suas próprias notas

---

## 📌 Estrutura do projeto

```text
.
├── app/                # Backend Rails
├── frontend/           # Frontend Vue
│   ├── src/
│   │   ├── components/
│   │   ├── services/
│   │   └── App.vue
├── Dockerfile          # Dockerfile do backend
├── docker-compose.yml
```

---

## 🔗 API

### Base URL

```text
http://localhost:3000/api/v1
```

### Endpoints

### Autenticação

| Método | Rota        | Descrição                              |
|--------|------------|-----------------------------------------|
| POST   | /login     | Acesso ao sistema                       |
| POST   | /register  | Cadastrar usuário                       |

### Notas

| Método | Rota        | Descrição                              |
|--------|------------|-----------------------------------------|
| GET    | /notes     | Listar notas com busca opcional `q`     |
| POST   | /notes     | Criar nota                              |
| PUT    | /notes/:id | Atualizar nota                          |
| DELETE | /notes/:id | Excluir nota                            |

### Exemplo de busca

```text
http://localhost:3000/api/v1/notes?q=carro
```

---

## 🧠 Decisões técnicas

- **Separação de responsabilidades**
  Backend e frontend desacoplados, permitindo evolução independente.

- **Autenticação com JWT**
  Simples, stateless e adequada para APIs.

- **Uso de Axios para comunicação com API**
  Centralização das requisições em uma camada de serviço no frontend.

- **Componentização no Vue**
  - `NoteForm`: responsável por criação e edição.
  - `NoteList`: responsável pela listagem, busca, paginação e ações.
  - `Auth (Login/Register)`: responsável pelo cadastro do usuário e pelo acesso ao sistema

- **Reutilização de componente**
  O `NoteForm` é utilizado tanto para criação quanto para edição, evitando duplicação de código.

- **Gerenciamento de estado no App.vue**
  O estado de edição (`selectedNote`) é controlado no componente pai, garantindo fluxo previsível.

- **Paginação no backend com Kaminari**
  Reduz carga no frontend e melhora a performance da listagem.

- **Busca no backend**
  A busca foi implementada no model `Note`, por meio de scope, mantendo o controller mais limpo.

- **Busca com suporte a acentos**
  Utilização da extensão `unaccent` do PostgreSQL para permitir buscas como `cafe` encontrando `café`.

- **Experiência do usuário (UX)**
  - loading em ações;
  - botões desabilitados durante requisições;
  - debounce na busca;
  - mensagens de erro e sucesso;
  - layout responsivo básico.

- **Docker**
  Uso de Docker Compose para subir backend, frontend e banco de dados de forma integrada.

---

## 📈 Possíveis melhorias

- Refresh token / expiração de sessão
- UI mais refinada com Tailwind ou outro design system
- Filtros avançados e ordenação
- Deploy em produção

---

## 👨‍💻 Autor

Marcelo Martins
Desenvolvedor Ruby on Rails