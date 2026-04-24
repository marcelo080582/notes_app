<template>
  <main class="container">
    <header class="header">
      <h1>Anotações</h1>
      <p>Crie, edite, liste e exclua suas anotações.</p>
    </header>

    <NoteForm
      :note="selectedNote"
      @note-created="refreshNotes"
      @note-updated="handleUpdated"
    />

    <div v-if="selectedNote" class="editing-info">
      <span>Editando: {{ selectedNote.title }}</span>

      <button @click="cancelEdit">
        Cancelar edição
      </button>
    </div>

    <NoteList
      ref="noteListRef"
      @edit-note="handleEdit"
    />
  </main>
</template>

<script setup>
import { ref } from 'vue'
import NoteForm from './components/NoteForm.vue'
import NoteList from './components/NoteList.vue'

const noteListRef = ref(null)
const selectedNote = ref(null)

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
  background: #f5f5f5;
  color: #222;
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.header {
  text-align: center;
  margin-bottom: 20px;
}

.header h1 {
  margin-bottom: 8px;
}

.header p {
  color: #555;
}

.editing-info {
  background: #fff8dc;
  border: 1px solid #f1c40f;
  padding: 12px;
  border-radius: 8px;
  margin-bottom: 20px;

  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.editing-info button {
  border: none;
  background: #555;
  color: white;
  padding: 8px 12px;
  border-radius: 4px;
  cursor: pointer;
}

@media (max-width: 600px) {
  .container {
    padding: 12px;
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