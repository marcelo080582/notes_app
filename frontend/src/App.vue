<template>
  <main class="container">
    <h1>Anotações</h1>

    <NoteForm
      :note="selectedNote"
      @note-created="refreshNotes"
      @note-updated="handleUpdated"
    />

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
  noteListRef.value.fetchNotes()
}

const handleEdit = (note) => {
  selectedNote.value = note
}

const handleUpdated = () => {
  selectedNote.value = null
  refreshNotes()
}
</script>

<style>
body {
  margin: 0;
  font-family: Arial, sans-serif;
  background: #f5f5f5;
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

h1 {
  text-align: center;
}
</style>