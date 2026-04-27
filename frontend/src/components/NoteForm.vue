<template>
  <div class="form-card">
    <h2>{{ note ? 'Editar Nota' : 'Criar Nota' }}</h2>

    <form @submit.prevent="handleSubmit">
      <div class="form-group">
        <label for="title">Título</label>

        <input
          id="title"
          v-model="title"
          type="text"
          maxlength="100"
          :disabled="loading"
          placeholder="Digite o título da nota"
        />

        <div class="field-footer">
          <span class="error" v-if="errors.title">
            {{ errors.title }}
          </span>

          <small>{{ title.length }}/100</small>
        </div>
      </div>

      <div class="form-group">
        <label for="content">Conteúdo</label>

        <textarea
          id="content"
          v-model="content"
          maxlength="1000"
          :disabled="loading"
          placeholder="Digite o conteúdo da nota"
        ></textarea>

        <div class="field-footer">
          <span class="error" v-if="errors.content">
            {{ errors.content }}
          </span>

          <small>{{ content.length }}/1000</small>
        </div>
      </div>

      <button
        type="submit"
        class="primary-btn"
        :disabled="loading"
      >
        {{ loading ? 'Salvando...' : note ? 'Atualizar' : 'Salvar' }}
      </button>
    </form>

    <p class="error message" v-if="apiError">
      {{ apiError }}
    </p>

    <p class="success message" v-if="successMessage">
      {{ successMessage }}
    </p>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import api from '../services/api'

const props = defineProps({
  note: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['note-created', 'note-updated'])

const title = ref('')
const content = ref('')
const errors = ref({})
const apiError = ref(null)
const successMessage = ref(null)
const loading = ref(false)

watch(
  () => props.note,
  (newNote) => {
    errors.value = {}
    apiError.value = null
    successMessage.value = null

    if (newNote) {
      title.value = newNote.title
      content.value = newNote.content || ''
    } else {
      title.value = ''
      content.value = ''
    }
  },
  { immediate: true }
)

watch([title, content], () => {
  errors.value = {}
  apiError.value = null
  successMessage.value = null
})

const validate = () => {
  errors.value = {}

  if (!title.value.trim()) {
    errors.value.title = 'Título é obrigatório'
  } else if (title.value.length > 100) {
    errors.value.title = 'Máximo de 100 caracteres'
  }

  if (content.value.length > 1000) {
    errors.value.content = 'Máximo de 1000 caracteres'
  }

  return Object.keys(errors.value).length === 0
}

const handleApiError = (error) => {
  const apiErrors = error.response?.data?.errors

  if (Array.isArray(apiErrors)) {
    apiError.value = apiErrors.join(', ')
  } else if (typeof apiErrors === 'object') {
    apiError.value = Object.values(apiErrors).flat().join(', ')
  } else if (error.response?.status === 404) {
    apiError.value = 'Nota não encontrada.'
  } else {
    apiError.value = 'Erro ao salvar nota.'
  }
}

const handleSubmit = async () => {
  if (!validate()) return

  loading.value = true
  apiError.value = null
  successMessage.value = null

  try {
    if (props.note) {
      await api.patch(`/api/v1/notes/${props.note.id}`, {
        note: {
          title: title.value,
          content: content.value
        }
      })

      successMessage.value = 'Nota atualizada com sucesso.'
      emit('note-updated')
    } else {
      await api.post('/api/v1/notes', {
        note: {
          title: title.value,
          content: content.value
        }
      })

      successMessage.value = 'Nota criada com sucesso.'
      emit('note-created')
    }

    title.value = ''
    content.value = ''
    errors.value = {}
  } catch (error) {
    handleApiError(error)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.form-card {
  background: white;
  padding: 24px;
  margin-bottom: 24px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.form-card h2 {
  margin: 0 0 20px;
  color: #111827;
}

.form-group {
  margin-bottom: 18px;
}

label {
  display: block;
  margin-bottom: 6px;
  font-weight: bold;
  color: #374151;
}

input,
textarea {
  width: 100%;
  padding: 10px 12px;
  box-sizing: border-box;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  font-size: 14px;
  background: white;
}

input:focus,
textarea:focus {
  outline: none;
  border-color: #2563eb;
}

textarea {
  min-height: 120px;
  resize: vertical;
}

.field-footer {
  margin-top: 6px;
  display: flex;
  justify-content: space-between;
  gap: 10px;
}

.field-footer small {
  margin-left: auto;
  color: #6b7280;
}

.primary-btn {
  background: #2563eb;
  color: white;
  border: none;
  padding: 11px 16px;
  cursor: pointer;
  width: 100%;
  border-radius: 8px;
  font-weight: bold;
}

.primary-btn:hover:not(:disabled) {
  background: #1d4ed8;
}

.primary-btn:disabled,
input:disabled,
textarea:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.error {
  color: #dc2626;
  font-size: 14px;
}

.success {
  color: #15803d;
  font-size: 14px;
}

.message {
  margin-top: 12px;
}
</style>