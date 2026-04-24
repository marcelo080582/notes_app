<template>
  <div>
    <h2>Criar Nota</h2>

    <form @submit.prevent="handleSubmit">
      <div>
        <label>Título</label>
        <input v-model="title" type="text" />
        <span v-if="errors.title">{{ errors.title }}</span>
      </div>

      <div>
        <label>Conteúdo</label>
        <textarea v-model="content"></textarea>
      </div>

      <button type="submit">Salvar</button>
    </form>

    <p v-if="apiError">{{ apiError }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import api from '../services/api'

const emit = defineEmits(['note-created'])

const title = ref('')
const content = ref('')
const errors = ref({})
const apiError = ref(null)

const validate = () => {
  errors.value = {}

  if (!title.value) {
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
    await api.post('/notes', {
      note: {
        title: title.value,
        content: content.value
      }
    })

    title.value = ''
    content.value = ''
    apiError.value = null

    emit('note-created')

    alert('Nota criada com sucesso!')
  } catch (error) {
    apiError.value = 'Erro ao criar nota'
  }
}
</script>