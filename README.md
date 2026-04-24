# 📝 Sistema de Anotações

Aplicação fullstack desenvolvida como teste técnico.

Permite criar, listar, editar, excluir e buscar anotações, com foco em boas práticas, organização de código, testes e experiência do usuário.

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

---

## 📦 Funcionalidades

- Criar anotação
- Listar anotações com paginação (20 por página)
- Editar anotação
- Excluir anotação
- Buscar anotações por título e conteúdo
- Validação no frontend e backend
- Feedback visual (loading, sucesso e erro)
- Layout responsivo básico

---

## ⚙️ Como rodar o projeto

---

## 🔹 Backend (Rails)

### Pré-requisitos

- Ruby instalado
- PostgreSQL instalado

### Passos

```bash
bundle install
rails db:create
rails db:migrate
rails s
```

Backend disponível em:

```
http://localhost:3000
```

---

## 🔹 Frontend (Vue)

### Pré-requisitos

- Node.js instalado

### Passos

```bash
cd frontend
npm install
npm run dev
```

Frontend disponível em:

```
http://localhost:5173
```

---

## 🧪 Rodando testes

```bash
bundle exec rspec
```

---

## 📌 Estrutura do projeto

```
.
├── app/                # Backend Rails
├── frontend/           # Frontend Vue
│   ├── src/
│   │   ├── components/
│   │   ├── services/
│   │   └── App.vue
```

---

## 🔗 API

### Base URL

```
http://localhost:3000/api/v1
```

---

### Endpoints

| Método | Rota        | Descrição                                      |
|--------|------------|-----------------------------------------------|
| GET    | /notes     | Listar notas (com busca opcional `q`)         |
| POST   | /notes     | Criar nota                                   |
| PUT    | /notes/:id | Atualizar nota                               |
| DELETE | /notes/:id | Excluir nota                                 |

---

### 🔎 Exemplo de busca

```
http://localhost:3000/api/v1/notes?q=carro
```

---

## 🧠 Decisões técnicas

- **Separação de responsabilidades**
  Backend e frontend desacoplados, permitindo evolução independente.

- **Uso de Axios para comunicação com API**
  Centralização das requisições em uma camada de serviço.

- **Componentização no Vue**
  - `NoteForm`: responsável por criação e edição
  - `NoteList`: responsável pela listagem, busca e ações

- **Reutilização de componente**
  O `NoteForm` é utilizado tanto para criação quanto para edição, evitando duplicação de código.

- **Gerenciamento de estado no App.vue**
  O estado de edição (`selectedNote`) é controlado no componente pai, garantindo fluxo previsível.

- **Paginação no backend com Kaminari**
  Reduz carga no frontend e melhora performance.

- **Busca no backend com suporte a acentuação**
  Utilização da extensão `unaccent` do PostgreSQL para tornar a busca insensível a acentos.

- **Experiência do usuário (UX)**
  - loading em ações
  - desabilitar botões durante requisições
  - debounce na busca
  - mensagens de erro e sucesso

---

## 📈 Possíveis melhorias

- Containerização com Docker
- Autenticação de usuários
- Testes no frontend
- UI mais refinada (ex: Tailwind ou outro design system)
- Filtros avançados e ordenação

---

## 👨‍💻 Autor

Marcelo Martins
Desenvolvedor Ruby on Rails