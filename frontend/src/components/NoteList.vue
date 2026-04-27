<template>
  <div class="notes-section">
    <div class="section-header">
      <h2>Anotações</h2>
      <span>{{ notes.length }} encontradas</span>
    </div>

    <div class="search-box">
      <label for="search">Pesquisar notas</label>

      <input
        id="search"
        v-model="search"
        type="text"
        placeholder="Digite título ou conteúdo..."
      />
    </div>

    <p class="loading" v-if="loading">Carregando anotações...</p>

    <p class="error message" v-if="error">
      {{ error }}
    </p>

    <p class="success message" v-if="successMessage">
      {{ successMessage }}
    </p>

    <div class="empty-state" v-if="notes.length === 0 && !loading && !error">
      Nenhuma anotação encontrada.
    </div>

    <div class="notes-grid">
      <div class="note-card" v-for="note in notes" :key="note.id">
        <div class="note-content">
          <h3>{{ note.title }}</h3>
          <p>{{ note.content || 'Sem conteúdo.' }}</p>
        </div>

        <div class="actions">
          <button
            type="button"
            @click="editNote(note)"
            class="edit-btn"
            :disabled="deletingId === note.id"
          >
            Editar
          </button>

          <button
            type="button"
            @click="deleteNote(note.id)"
            class="delete-btn"
            :disabled="deletingId === note.id"
          >
            {{ deletingId === note.id ? 'Excluindo...' : 'Excluir' }}
          </button>
        </div>
      </div>
    </div>

    <div class="pagination" v-if="totalPages > 1">
      <button
        type="button"
        :disabled="currentPage === 1 || loading"
        @click="changePage(currentPage - 1)"
      >
        Anterior
      </button>

      <span>Página {{ currentPage }} de {{ totalPages }}</span>

      <button
        type="button"
        :disabled="currentPage === totalPages || loading"
        @click="changePage(currentPage + 1)"
      >
        Próxima
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue'
import api from '../services/api'

const emit = defineEmits(['edit-note'])

const notes = ref([])
const loading = ref(false)
const error = ref(null)
const successMessage = ref(null)
const deletingId = ref(null)
const search = ref('')

const currentPage = ref(1)
const totalPages = ref(1)

let searchTimeout = null

const fetchNotes = async (page = 1) => {
  loading.value = true
  error.value = null
  successMessage.value = null

  try {
    const response = await api.get('/api/v1/notes', {
      params: {
        page,
        q: search.value
      }
    })

    notes.value = response.data.notes
    currentPage.value = response.data.meta.current_page
    totalPages.value = response.data.meta.total_pages
  } catch (e) {
    if (e.response?.status === 401) {
      error.value = 'Sua sessão expirou. Faça login novamente.'
    } else {
      error.value = 'Erro ao carregar anotações.'
    }
  } finally {
    loading.value = false
  }
}

watch(search, () => {
  clearTimeout(searchTimeout)

  searchTimeout = setTimeout(() => {
    fetchNotes(1)
  }, 400)
})

const changePage = (page) => {
  fetchNotes(page)
}

const editNote = (note) => {
  error.value = null
  successMessage.value = null
  emit('edit-note', note)
}

const deleteNote = async (id) => {
  const confirmed = confirm('Tem certeza que deseja excluir esta anotação?')

  if (!confirmed) return

  deletingId.value = id
  error.value = null
  successMessage.value = null

  try {
    await api.delete(`/api/v1/notes/${id}`)

    successMessage.value = 'Nota excluída com sucesso.'

    const shouldGoToPreviousPage =
      notes.value.length === 1 && currentPage.value > 1

    const nextPage = shouldGoToPreviousPage
      ? currentPage.value - 1
      : currentPage.value

    await fetchNotes(nextPage)
  } catch (e) {
    if (e.response?.status === 404) {
      error.value = 'Nota não encontrada.'
    } else {
      error.value = 'Erro ao excluir anotação.'
    }
  } finally {
    deletingId.value = null
  }
}

onMounted(() => {
  fetchNotes()
})

defineExpose({
  fetchNotes
})
</script>

<style scoped>
.notes-section {
  margin-top: 24px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 14px;
  gap: 12px;
}

.section-header h2 {
  margin: 0;
  color: #111827;
}

.section-header span {
  color: #6b7280;
  font-size: 14px;
}

.search-box {
  background: white;
  padding: 20px;
  border-radius: 12px;
  margin-bottom: 18px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.search-box label {
  display: block;
  margin-bottom: 8px;
  font-weight: bold;
  color: #374151;
}

.search-box input {
  width: 100%;
  padding: 10px 12px;
  box-sizing: border-box;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  font-size: 14px;
}

.search-box input:focus {
  outline: none;
  border-color: #2563eb;
}

.notes-grid {
  display: grid;
  gap: 16px;
}

.note-card {
  background: white;
  padding: 20px;
  border-radius: 12px;
  display: flex;
  justify-content: space-between;
  gap: 16px;
  align-items: flex-start;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.note-content {
  flex: 1;
  min-width: 0;
}

.note-card h3 {
  margin: 0 0 8px;
  color: #111827;
  word-break: break-word;
}

.note-card p {
  margin: 0;
  color: #4b5563;
  line-height: 1.5;
  word-break: break-word;
}

.actions {
  display: flex;
  gap: 8px;
  flex-shrink: 0;
}

.edit-btn,
.delete-btn,
.pagination button {
  border: none;
  padding: 8px 12px;
  cursor: pointer;
  border-radius: 6px;
  font-weight: bold;
}

.edit-btn {
  background: #facc15;
  color: #422006;
}

.edit-btn:hover:not(:disabled) {
  background: #eab308;
}

.delete-btn {
  background: #dc2626;
  color: white;
}

.delete-btn:hover:not(:disabled) {
  background: #b91c1c;
}

button:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.pagination {
  margin-top: 22px;
  display: flex;
  justify-content: center;
  gap: 12px;
  align-items: center;
  flex-wrap: wrap;
}

.pagination button {
  background: #2563eb;
  color: white;
}

.pagination button:hover:not(:disabled) {
  background: #1d4ed8;
}

.loading {
  color: #6b7280;
}

.message {
  padding: 12px;
  border-radius: 8px;
  font-size: 14px;
}

.error {
  background: #fef2f2;
  color: #dc2626;
}

.success {
  background: #f0fdf4;
  color: #15803d;
}

.empty-state {
  background: white;
  padding: 20px;
  border-radius: 12px;
  color: #6b7280;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

@media (max-width: 700px) {
  .section-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .note-card {
    flex-direction: column;
  }

  .actions {
    width: 100%;
  }

  .actions button {
    flex: 1;
  }
}
</style>