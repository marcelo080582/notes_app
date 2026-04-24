<template>
  <main>
    <h1>Sistema de Anotações</h1>

    <NoteForm @note-created="refreshNotes" />

    <hr />

    <NoteList ref="noteListRef" />
  </main>
</template>

<script setup>
import { ref } from 'vue'
import NoteForm from './components/NoteForm.vue'
import NoteList from './components/NoteList.vue'

const noteListRef = ref(null)

const refreshNotes = () => {
  noteListRef.value.fetchNotes()
}
</script>