<template>
  <main>
    <h1>Sistema de Anotações</h1>

    <NoteForm
      :note="selectedNote"
      @note-created="refreshNotes"
      @note-updated="handleUpdated"
    />

    <hr />

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