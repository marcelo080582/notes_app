<template>
  <div class="auth-card">
    <h2>Criar conta</h2>
    <p class="auth-subtitle">Preencha os dados para acessar suas anotações.</p>

    <form @submit.prevent="handleSubmit" class="auth-form">
      <div class="field">
        <input
          v-model="name"
          type="text"
          placeholder="Nome"
        />

        <p class="error" v-if="nameError">
          {{ nameError }}
        </p>
      </div>

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

      <div class="field">
        <input
          v-model="passwordConfirmation"
          type="password"
          placeholder="Confirmar senha"
        />

        <p class="error" v-if="passwordConfirmationError">
          {{ passwordConfirmationError }}
        </p>
      </div>

      <p class="error" v-if="errorMessage">
        {{ errorMessage }}
      </p>

      <button type="submit" :disabled="loading || !isFormValid">
        {{ loading ? 'Criando conta...' : 'Criar conta' }}
      </button>
    </form>

    <p class="auth-link">
      Já tem conta?
      <button type="button" @click="$emit('change-mode')">
        Entrar
      </button>
    </p>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { register } from '../services/auth'

const emit = defineEmits(['authenticated', 'change-mode'])

const name = ref('')
const email = ref('')
const password = ref('')
const passwordConfirmation = ref('')
const loading = ref(false)

const errorMessage = ref('')
const nameError = ref('')
const emailError = ref('')
const passwordError = ref('')
const passwordConfirmationError = ref('')

const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

const isFormValid = computed(() => {
  return (
    name.value.trim().length > 0 &&
    emailRegex.test(email.value) &&
    password.value.length >= 6 &&
    password.value === passwordConfirmation.value
  )
})

watch(name, (value) => {
  errorMessage.value = ''
  nameError.value = value.trim() ? '' : ''
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

  if (!value) {
    passwordError.value = ''
  } else if (value.length < 6) {
    passwordError.value = 'A senha deve ter pelo menos 6 caracteres.'
  } else {
    passwordError.value = ''
  }

  if (
    passwordConfirmation.value &&
    value !== passwordConfirmation.value
  ) {
    passwordConfirmationError.value = 'A confirmação de senha não confere.'
  } else {
    passwordConfirmationError.value = ''
  }
})

watch(passwordConfirmation, (value) => {
  errorMessage.value = ''

  if (!value) {
    passwordConfirmationError.value = ''
  } else if (password.value !== value) {
    passwordConfirmationError.value = 'A confirmação de senha não confere.'
  } else {
    passwordConfirmationError.value = ''
  }
})

function validate() {
  nameError.value = ''
  emailError.value = ''
  passwordError.value = ''
  passwordConfirmationError.value = ''

  if (!name.value.trim()) {
    nameError.value = 'Nome é obrigatório.'
  }

  if (!email.value.trim()) {
    emailError.value = 'Email é obrigatório.'
  } else if (!emailRegex.test(email.value)) {
    emailError.value = 'Email inválido.'
  }

  if (!password.value) {
    passwordError.value = 'Senha é obrigatória.'
  } else if (password.value.length < 6) {
    passwordError.value = 'A senha deve ter pelo menos 6 caracteres.'
  }

  if (!passwordConfirmation.value) {
    passwordConfirmationError.value = 'Confirmação de senha é obrigatória.'
  } else if (password.value !== passwordConfirmation.value) {
    passwordConfirmationError.value = 'A confirmação de senha não confere.'
  }

  return (
    !nameError.value &&
    !emailError.value &&
    !passwordError.value &&
    !passwordConfirmationError.value
  )
}

async function handleSubmit() {
  errorMessage.value = ''

  if (!validate()) return

  loading.value = true

  try {
    const data = await register({
      name: name.value,
      email: email.value,
      password: password.value,
      password_confirmation: passwordConfirmation.value
    })

    emit('authenticated', data.user)
  } catch (error) {
    errorMessage.value = 'Não foi possível criar sua conta.'
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