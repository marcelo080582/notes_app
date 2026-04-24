<template>
  <div>
    <h2>Anotações</h2>

    <p v-if="loading">Carregando...</p>
    <p v-if="error">{{ error }}</p>

    <div v-if="notes.length === 0 && !loading">
      Nenhuma anotação encontrada.
    </div>

    <div class="notes-grid">
      <div class="note-card" v-for="note in notes" :key="note.id">
        <h3>{{ note.title }}</h3>
        <p>{{ note.content }}</p>

        <div class="actions">
          <button @click="editNote(note)" class="edit-btn">
            Editar
          </button>

          <button @click="deleteNote(note.id)" class="delete-btn">
            Excluir
          </button>
        </div>
      </div>
    </div>

    <div class="pagination" v-if="totalPages > 1">
      <button
        :disabled="currentPage === 1"
        @click="changePage(currentPage - 1)"
      >
        Anterior
      </button>

      <span>Página {{ currentPage }} de {{ totalPages }}</span>

      <button
        :disabled="currentPage === totalPages"
        @click="changePage(currentPage + 1)"
      >
        Próxima
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../services/api'

const emit = defineEmits(['edit-note'])

const notes = ref([])
const loading = ref(false)
const error = ref(null)

const currentPage = ref(1)
const totalPages = ref(1)

const fetchNotes = async (page = 1) => {
  loading.value = true
  error.value = null

  try {
    const response = await api.get('/notes', {
      params: { page }
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

const changePage = (page) => {
  fetchNotes(page)
}

const editNote = (note) => {
  emit('edit-note', note)
}

const deleteNote = async (id) => {
  const confirmed = confirm('Tem certeza que deseja excluir esta anotação?')

  if (!confirmed) return

  try {
    await api.delete(`/notes/${id}`)
    fetchNotes(currentPage.value)
  } catch (e) {
    error.value = 'Erro ao excluir anotação.'
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
.notes-grid {
  display: grid;
  gap: 15px;
}

.note-card {
  background: white;
  padding: 15px;
  border-radius: 8px;
}

.actions {
  margin-top: 10px;
  display: flex;
  gap: 10px;
}

.edit-btn {
  background: #f1c40f;
  border: none;
  padding: 6px 10px;
  cursor: pointer;
}

.delete-btn {
  background: #e74c3c;
  color: white;
  border: none;
  padding: 6px 10px;
  cursor: pointer;
}

.pagination {
  margin-top: 20px;
  text-align: center;
}
</style>