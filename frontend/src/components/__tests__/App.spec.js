import { mount, flushPromises } from '@vue/test-utils'
import { describe, it, expect, vi, beforeEach } from 'vitest'
import App from '../../App.vue'
import * as authService from '../../services/auth'

vi.mock('../../services/auth', () => ({
  getCurrentUser: vi.fn(),
  isAuthenticated: vi.fn(),
  logout: vi.fn()
}))

describe('App', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  const mountApp = () => {
    return mount(App, {
      global: {
        stubs: {
          LoginForm: {
            emits: ['authenticated', 'change-mode'],
            template: `
              <button
                data-test="login-form"
                @click="$emit('change-mode')"
              >
                Login
              </button>
            `
          },
          RegisterForm: {
            emits: ['authenticated', 'change-mode'],
            template: '<div data-test="register-form">Register</div>'
          },
          NoteForm: {
            emits: ['note-created', 'note-updated'],
            template: '<div data-test="note-form">NoteForm</div>'
          },
          NoteList: {
            emits: ['edit-note'],
            template: '<div data-test="note-list">NoteList</div>'
          }
        }
      }
    })
  }

  it('shows login form when user is not authenticated', async () => {
    authService.isAuthenticated.mockReturnValue(false)

    const wrapper = mountApp()
    await flushPromises()

    expect(wrapper.find('[data-test="login-form"]').exists()).toBe(true)
  })

  it('shows register form when changing auth mode', async () => {
    authService.isAuthenticated.mockReturnValue(false)

    const wrapper = mountApp()
    await flushPromises()

    await wrapper.find('[data-test="login-form"]').trigger('click')

    expect(wrapper.find('[data-test="register-form"]').exists()).toBe(true)
  })

  it('shows notes when user is authenticated', async () => {
    authService.isAuthenticated.mockReturnValue(true)
    authService.getCurrentUser.mockReturnValue({
      id: 1,
      name: 'Marcelo',
      email: 'marcelo@email.com'
    })

    const wrapper = mountApp()
    await flushPromises()

    expect(wrapper.text()).toContain('Olá, Marcelo')
    expect(wrapper.find('[data-test="note-form"]').exists()).toBe(true)
    expect(wrapper.find('[data-test="note-list"]').exists()).toBe(true)
  })

  it('logs out user', async () => {
    authService.isAuthenticated.mockReturnValue(true)
    authService.getCurrentUser.mockReturnValue({
      id: 1,
      name: 'Marcelo',
      email: 'marcelo@email.com'
    })

    const wrapper = mountApp()
    await flushPromises()

    await wrapper.find('.user-info button').trigger('click')

    expect(authService.logout).toHaveBeenCalled()
    expect(wrapper.find('[data-test="login-form"]').exists()).toBe(true)
  })
})