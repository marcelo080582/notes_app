<template>
  <div class="auth-card">
    <h2>Entrar</h2>
    <p class="auth-subtitle">Acesse sua conta para gerenciar suas anotações.</p>

    <form @submit.prevent="handleSubmit" class="auth-form">
      <div class="field">
        <input
          v-model="email"
          type="email"
          placeholder="Email"
        />

        <p class="error" v-if="emailError">
          {{ emailError }}
        </p>
      </div>

      <div class="field">
        <input
          v-model="password"
          type="password"
          placeholder="Senha"
        />

        <p class="error" v-if="passwordError">
          {{ passwordError }}
        </p>
      </div>

      <p class="error" v-if="errorMessage">
        {{ errorMessage }}
      </p>

      <button type="submit" :disabled="loading || !isFormValid">
        {{ loading ? 'Entrando...' : 'Entrar' }}
      </button>
    </form>

    <p class="auth-link">
      Ainda não tem conta?
      <button type="button" @click="$emit('change-mode')">
        Criar conta
      </button>
    </p>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { login } from '../services/auth'

const emit = defineEmits(['authenticated', 'change-mode'])

const email = ref('')
const password = ref('')
const loading = ref(false)
const errorMessage = ref('')
const emailError = ref('')
const passwordError = ref('')

const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

const isFormValid = computed(() => {
  return emailRegex.test(email.value) && password.value.trim().length > 0
})

watch(email, (value) => {
  errorMessage.value = ''

  if (!value.trim()) {
    emailError.value = ''
  } else if (!emailRegex.test(value)) {
    emailError.value = 'Email inválido.'
  } else {
    emailError.value = ''
  }
})

watch(password, (value) => {
  errorMessage.value = ''

  if (!value.trim()) {
    passwordError.value = ''
  } else {
    passwordError.value = ''
  }
})

function validate() {
  emailError.value = ''
  passwordError.value = ''

  if (!email.value.trim()) {
    emailError.value = 'Email é obrigatório.'
  } else if (!emailRegex.test(email.value)) {
    emailError.value = 'Email inválido.'
  }

  if (!password.value.trim()) {
    passwordError.value = 'Senha é obrigatória.'
  }

  return !emailError.value && !passwordError.value
}

async function handleSubmit() {
  errorMessage.value = ''

  if (!validate()) return

  loading.value = true

  try {
    const data = await login({
      email: email.value,
      password: password.value
    })

    emit('authenticated', data.user)
  } catch (error) {
    errorMessage.value = 'Email ou senha inválidos.'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-card {
  text-align: center;
}

.auth-card h2 {
  margin: 0 0 8px;
  color: #111827;
  font-size: 28px;
}

.auth-subtitle {
  margin: 0 0 24px;
  color: #6b7280;
  font-size: 14px;
}

.auth-form {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.field {
  text-align: left;
}

.auth-form input {
  width: 100%;
  padding: 11px 12px;
  box-sizing: border-box;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  font-size: 14px;
}

.auth-form input:focus {
  outline: none;
  border-color: #2563eb;
}

.auth-form button {
  margin-top: 4px;
  background: #2563eb;
  color: white;
  border: none;
  padding: 11px 16px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: bold;
}

.auth-form button:hover:not(:disabled) {
  background: #1d4ed8;
}

.auth-form button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.auth-link {
  margin: 18px 0 0;
  color: #374151;
}

.auth-link button {
  border: none;
  background: transparent;
  color: #2563eb;
  cursor: pointer;
  font-weight: bold;
}

.auth-link button:hover {
  text-decoration: underline;
}

.error {
  background: #fef2f2;
  color: #dc2626;
  padding: 8px 10px;
  border-radius: 8px;
  font-size: 14px;
  margin: 6px 0 0;
}
</style>