import api from './api'

const TOKEN_KEY = 'notes_app_token'
const USER_KEY = 'notes_app_user'

export async function login(credentials) {
  const response = await api.post('/login', credentials)

  localStorage.setItem(TOKEN_KEY, response.data.token)
  localStorage.setItem(USER_KEY, JSON.stringify(response.data.user))

  return response.data
}

export async function register(data) {
  const response = await api.post('/register', data)

  localStorage.setItem(TOKEN_KEY, response.data.token)
  localStorage.setItem(USER_KEY, JSON.stringify(response.data.user))

  return response.data
}

export function logout() {
  localStorage.removeItem(TOKEN_KEY)
  localStorage.removeItem(USER_KEY)
}

export function getToken() {
  return localStorage.getItem(TOKEN_KEY)
}

export function getCurrentUser() {
  const user = localStorage.getItem(USER_KEY)

  return user ? JSON.parse(user) : null
}

export function isAuthenticated() {
  return !!getToken()
}