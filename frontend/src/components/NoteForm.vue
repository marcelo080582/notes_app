<template>
  <div class="form-card">
    <h2>{{ note ? 'Editar Nota' : 'Criar Nota' }}</h2>

    <form @submit.prevent="handleSubmit">
      <div class="form-group">
        <label>Título</label>
        <input v-model="title" type="text" />
        <span class="error" v-if="errors.title">{{ errors.title }}</span>
      </div>

      <div class="form-group">
        <label>Conteúdo</label>
        <textarea v-model="content"></textarea>
        <span class="error" v-if="errors.content">{{ errors.content }}</span>
      </div>

      <button type="submit" class="primary-btn">
        {{ note ? 'Atualizar' : 'Salvar' }}
      </button>
    </form>

    <p class="error" v-if="apiError">{{ apiError }}</p>
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

watch(
  () => props.note,
  (newNote) => {
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

const handleSubmit = async () => {
  if (!validate()) return

  try {
    if (props.note) {
      await api.put(`/notes/${props.note.id}`, {
        note: {
          title: title.value,
          content: content.value
        }
      })

      emit('note-updated')
    } else {
      await api.post('/notes', {
        note: {
          title: title.value,
          content: content.value
        }
      })

      emit('note-created')
    }

    title.value = ''
    content.value = ''
    errors.value = {}
    apiError.value = null
  } catch (error) {
    apiError.value = 'Erro ao salvar nota.'
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
}

.primary-btn {
  background: #3498db;
  color: white;
  border: none;
  padding: 10px;
  cursor: pointer;
  width: 100%;
}

.primary-btn:hover {
  background: #2980b9;
}

.error {
  color: red;
  font-size: 14px;
}
</style>