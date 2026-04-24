<template>
  <div class="form-card">
    <h2>{{ note ? 'Editar Nota' : 'Criar Nota' }}</h2>

    <form @submit.prevent="handleSubmit">
      <div class="form-group">
        <label>Título</label>

        <input
          v-model="title"
          type="text"
          :disabled="loading"
        />

        <span class="error" v-if="errors.title">
          {{ errors.title }}
        </span>
      </div>

      <div class="form-group">
        <label>Conteúdo</label>

        <textarea
          v-model="content"
          :disabled="loading"
        ></textarea>

        <span class="error" v-if="errors.content">
          {{ errors.content }}
        </span>
      </div>

      <button
        type="submit"
        class="primary-btn"
        :disabled="loading"
      >
        {{ loading ? 'Salvando...' : note ? 'Atualizar' : 'Salvar' }}
      </button>
    </form>

    <p class="error" v-if="apiError">
      {{ apiError }}
    </p>

    <p class="success" v-if="successMessage">
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
      await api.put(`/notes/${props.note.id}`, {
        note: {
          title: title.value,
          content: content.value
        }
      })

      successMessage.value = 'Nota atualizada com sucesso.'
      emit('note-updated')
    } else {
      await api.post('/notes', {
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
  padding: 20px;
  margin-bottom: 20px;
  border-radius: 8px;
}

.form-group {
  margin-bottom: 15px;
}

input,
textarea {
  width: 100%;
  padding: 8px;
  margin-top: 5px;
  box-sizing: border-box;
}

textarea {
  min-height: 100px;
}

.primary-btn {
  background: #3498db;
  color: white;
  border: none;
  padding: 10px;
  cursor: pointer;
  width: 100%;
}

.primary-btn:hover:not(:disabled) {
  background: #2980b9;
}

.primary-btn:disabled,
input:disabled,
textarea:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.error {
  color: red;
  font-size: 14px;
}

.success {
  color: green;
  font-size: 14px;
}
</style>