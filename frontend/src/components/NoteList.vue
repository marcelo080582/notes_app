<template>
  <div class="notes-section">
    <h2>Anotações</h2>

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

    <p class="error" v-if="error">
      {{ error }}
    </p>

    <p class="success" v-if="successMessage">
      {{ successMessage }}
    </p>

    <div class="empty-state" v-if="notes.length === 0 && !loading">
      Nenhuma anotação encontrada.
    </div>

    <div class="notes-grid">
      <div class="note-card" v-for="note in notes" :key="note.id">
        <h3>{{ note.title }}</h3>
        <p>{{ note.content || 'Sem conteúdo.' }}</p>

        <div class="actions">
          <button
            @click="editNote(note)"
            class="edit-btn"
            :disabled="deletingId === note.id"
          >
            Editar
          </button>

          <button
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
        :disabled="currentPage === 1 || loading"
        @click="changePage(currentPage - 1)"
      >
        Anterior
      </button>

      <span>Página {{ currentPage }} de {{ totalPages }}</span>

      <button
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
    const response = await api.get('/notes', {
      params: {
        page,
        q: search.value
      }
    })

    notes.value = response.data.notes
    currentPage.value = response.data.meta.current_page
    totalPages.value = response.data.meta.total_pages
  } catch (e) {
    error.value = 'Erro ao carregar anotações.'
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
    await api.delete(`/notes/${id}`)

    successMessage.value = 'Nota excluída com sucesso.'

    const shouldGoToPreviousPage =
      notes.value.length === 1 && currentPage.value > 1

    const nextPage = shouldGoToPreviousPage
      ? currentPage.value - 1
      : currentPage.value

    await fetchNotes(nextPage)
  } catch (e) {
    error.value = 'Erro ao excluir anotação.'
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
  margin-top: 20px;
}

.search-box {
  background: white;
  padding: 15px;
  border-radius: 8px;
  margin-bottom: 15px;
}

.search-box label {
  display: block;
  margin-bottom: 6px;
  font-weight: bold;
}

.search-box input {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
}

.notes-grid {
  display: grid;
  gap: 15px;
}

.note-card {
  background: white;
  padding: 15px;
  border-radius: 8px;
}

.note-card h3 {
  margin-top: 0;
  word-break: break-word;
}

.note-card p {
  word-break: break-word;
}

.actions {
  margin-top: 10px;
  display: flex;
  gap: 10px;
}

.edit-btn,
.delete-btn,
.pagination button {
  border: none;
  padding: 8px 12px;
  cursor: pointer;
  border-radius: 4px;
}

.edit-btn {
  background: #f1c40f;
}

.delete-btn {
  background: #e74c3c;
  color: white;
}

button:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: center;
  gap: 12px;
  align-items: center;
  flex-wrap: wrap;
}

.loading {
  color: #555;
}

.error {
  color: red;
  font-size: 14px;
}

.success {
  color: green;
  font-size: 14px;
}

.empty-state {
  background: white;
  padding: 15px;
  border-radius: 8px;
  color: #555;
}
</style>