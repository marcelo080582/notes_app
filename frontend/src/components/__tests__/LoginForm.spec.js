import { mount } from '@vue/test-utils'
import { describe, it, expect, vi, beforeEach } from 'vitest'
import LoginForm from '../LoginForm.vue'
import * as authService from '../../services/auth'

vi.mock('../../services/auth', () => ({
  login: vi.fn()
}))

describe('LoginForm', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('renders login form', () => {
    const wrapper = mount(LoginForm)

    expect(wrapper.text()).toContain('Entrar')
    expect(wrapper.find('input[type="email"]').exists()).toBe(true)
    expect(wrapper.find('input[type="password"]').exists()).toBe(true)
  })

  it('emits authenticated when login succeeds', async () => {
    authService.login.mockResolvedValue({
      user: {
        id: 1,
        name: 'Marcelo',
        email: 'marcelo@email.com'
      },
      token: 'fake-token'
    })

    const wrapper = mount(LoginForm)

    await wrapper.find('input[type="email"]').setValue('marcelo@email.com')
    await wrapper.find('input[type="password"]').setValue('123456')
    await wrapper.find('form').trigger('submit.prevent')

    expect(authService.login).toHaveBeenCalledWith({
      email: 'marcelo@email.com',
      password: '123456'
    })

    expect(wrapper.emitted('authenticated')).toBeTruthy()
    expect(wrapper.emitted('authenticated')[0][0]).toEqual({
      id: 1,
      name: 'Marcelo',
      email: 'marcelo@email.com'
    })
  })

  it('shows error when email is invalid', async () => {
    const wrapper = mount(LoginForm)

    await wrapper.find('input[type="email"]').setValue('email_invalido')
    await wrapper.find('input[type="password"]').setValue('123456')
    await wrapper.find('form').trigger('submit.prevent')

    expect(wrapper.text()).toContain('Email inválido.')
    expect(authService.login).not.toHaveBeenCalled()
  })

  it('shows error when password is blank', async () => {
    const wrapper = mount(LoginForm)

    await wrapper.find('input[type="email"]').setValue('marcelo@email.com')
    await wrapper.find('input[type="password"]').setValue('')
    await wrapper.find('form').trigger('submit.prevent')

    expect(wrapper.text()).toContain('Senha é obrigatória.')
    expect(authService.login).not.toHaveBeenCalled()
  })

  it('shows error message when login fails', async () => {
    authService.login.mockRejectedValue(new Error('Invalid credentials'))

    const wrapper = mount(LoginForm)

    await wrapper.find('input[type="email"]').setValue('marcelo@email.com')
    await wrapper.find('input[type="password"]').setValue('wrong')
    await wrapper.find('form').trigger('submit.prevent')

    expect(wrapper.text()).toContain('Email ou senha inválidos.')
  })

  it('emits change-mode when clicking create account', async () => {
    const wrapper = mount(LoginForm)

    await wrapper.find('.auth-link button').trigger('click')

    expect(wrapper.emitted('change-mode')).toBeTruthy()
  })
})