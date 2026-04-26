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

### Frontend
- Vue 3
- Vite
- Axios

### Infra
- Docker
- Docker Compose

---

## 📦 Funcionalidades

- Criar anotação
- Listar anotações com paginação (20 por página)
- Editar anotação
- Excluir anotação
- Buscar anotações por título e conteúdo
- Busca com suporte a acentos
- Validação no frontend e backend
- Feedback visual (loading, sucesso e erro)
- Layout responsivo básico

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

- **Uso de Axios para comunicação com API**
  Centralização das requisições em uma camada de serviço no frontend.

- **Componentização no Vue**
  - `NoteForm`: responsável por criação e edição.
  - `NoteList`: responsável pela listagem, busca, paginação e ações.

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

- Autenticação de usuários
- UI mais refinada com Tailwind ou outro design system
- Filtros avançados e ordenação
- Deploy em produção

---

## 👨‍💻 Autor

Marcelo Martins
Desenvolvedor Ruby on Rails