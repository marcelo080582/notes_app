<template>
  <main class="container">
    <section v-if="!user" class="auth-container">
      <LoginForm
        v-if="authMode === 'login'"
        @authenticated="handleAuthenticated"
        @change-mode="authMode = 'register'"
      />

      <RegisterForm
        v-else
        @authenticated="handleAuthenticated"
        @change-mode="authMode = 'login'"
      />
    </section>

    <section v-else>
      <header class="header">
        <div class="header-content">
          <div>
            <h1>Anotações</h1>
            <p>Crie, edite, liste e exclua suas anotações.</p>
          </div>

          <div class="user-info">
            <span>Olá, {{ user.name }}</span>

            <button type="button" @click="handleLogout">
              Sair
            </button>
          </div>
        </div>
      </header>

      <NoteForm
        :note="selectedNote"
        @note-created="refreshNotes"
        @note-updated="handleUpdated"
      />

      <div v-if="selectedNote" class="editing-info">
        <span>Editando: {{ selectedNote.title }}</span>

        <button type="button" @click="cancelEdit">
          Cancelar edição
        </button>
      </div>

      <NoteList
        ref="noteListRef"
        @edit-note="handleEdit"
      />
    </section>
  </main>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import NoteForm from './components/NoteForm.vue'
import NoteList from './components/NoteList.vue'
import LoginForm from './components/LoginForm.vue'
import RegisterForm from './components/RegisterForm.vue'
import { getCurrentUser, isAuthenticated, logout } from './services/auth'

const noteListRef = ref(null)
const selectedNote = ref(null)
const user = ref(null)
const authMode = ref('login')

onMounted(() => {
  if (isAuthenticated()) {
    user.value = getCurrentUser()
  }
})

const handleAuthenticated = (authenticatedUser) => {
  user.value = authenticatedUser
}

const handleLogout = () => {
  logout()
  user.value = null
  selectedNote.value = null
}

const refreshNotes = () => {
  noteListRef.value?.fetchNotes()
}

const handleEdit = (note) => {
  selectedNote.value = note

  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}

const handleUpdated = () => {
  selectedNote.value = null
  refreshNotes()
}

const cancelEdit = () => {
  selectedNote.value = null
}
</script>

<style>
body {
  margin: 0;
  font-family: Arial, sans-serif;
  background: #f3f4f6;
  color: #1f2937;
}

.container {
  max-width: 900px;
  margin: 0 auto;
  padding: 32px 20px;
}

.auth-container {
  max-width: 420px;
  margin: 80px auto;
  background: white;
  padding: 28px;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
}

.header {
  background: white;
  border-radius: 12px;
  padding: 24px;
  margin-bottom: 24px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
}

.header h1 {
  margin: 0 0 6px;
  font-size: 36px;
  color: #111827;
}

.header p {
  margin: 0;
  color: #6b7280;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 12px;
  white-space: nowrap;
}

.user-info span {
  font-size: 14px;
  color: #374151;
}

.user-info button {
  border: none;
  background: #dc2626;
  color: white;
  padding: 9px 14px;
  border-radius: 6px;
  cursor: pointer;
  font-weight: bold;
}

.user-info button:hover {
  background: #b91c1c;
}

.editing-info {
  background: #fffbeb;
  border: 1px solid #facc15;
  padding: 14px;
  border-radius: 10px;
  margin-bottom: 20px;

  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.editing-info button {
  border: none;
  background: #4b5563;
  color: white;
  padding: 8px 12px;
  border-radius: 6px;
  cursor: pointer;
}

@media (max-width: 700px) {
  .container {
    padding: 16px 12px;
  }

  .header-content {
    flex-direction: column;
    align-items: flex-start;
  }

  .user-info {
    width: 100%;
    justify-content: space-between;
  }

  .header h1 {
    font-size: 30px;
  }

  .editing-info {
    align-items: stretch;
    flex-direction: column;
  }

  .editing-info button {
    width: 100%;
  }
}
</style>