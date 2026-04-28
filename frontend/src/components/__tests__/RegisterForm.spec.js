import { mount } from '@vue/test-utils'
import { describe, it, expect, vi, beforeEach } from 'vitest'
import RegisterForm from '../RegisterForm.vue'
import * as authService from '../../services/auth'

vi.mock('../../services/auth', () => ({
  register: vi.fn()
}))

describe('RegisterForm', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('renders register form', () => {
    const wrapper = mount(RegisterForm)

    expect(wrapper.text()).toContain('Criar conta')
    expect(wrapper.find('input[type="text"]').exists()).toBe(true)
    expect(wrapper.find('input[type="email"]').exists()).toBe(true)
    expect(wrapper.findAll('input[type="password"]')).toHaveLength(2)
  })

  it('emits authenticated when register succeeds', async () => {
    authService.register.mockResolvedValue({
      user: {
        id: 1,
        name: 'Marcelo',
        email: 'marcelo@email.com'
      },
      token: 'fake-token'
    })

    const wrapper = mount(RegisterForm)

    await wrapper.find('input[type="text"]').setValue('Marcelo')
    await wrapper.find('input[type="email"]').setValue('marcelo@email.com')

    const passwordInputs = wrapper.findAll('input[type="password"]')
    await passwordInputs[0].setValue('123456')
    await passwordInputs[1].setValue('123456')

    await wrapper.find('form').trigger('submit.prevent')

    expect(authService.register).toHaveBeenCalledWith({
      name: 'Marcelo',
      email: 'marcelo@email.com',
      password: '123456',
      password_confirmation: '123456'
    })

    expect(wrapper.emitted('authenticated')).toBeTruthy()
    expect(wrapper.emitted('authenticated')[0][0]).toEqual({
      id: 1,
      name: 'Marcelo',
      email: 'marcelo@email.com'
    })
  })

  it('shows error message when register fails', async () => {
    authService.register.mockRejectedValue(new Error('Invalid data'))

    const wrapper = mount(RegisterForm)

    await wrapper.find('input[type="text"]').setValue('Marcelo')
    await wrapper.find('input[type="email"]').setValue('marcelo@email.com')

    const passwordInputs = wrapper.findAll('input[type="password"]')
    await passwordInputs[0].setValue('123456')
    await passwordInputs[1].setValue('123456')

    await wrapper.find('form').trigger('submit.prevent')

    expect(wrapper.text()).toContain('Não foi possível criar sua conta.')
  })

  it('shows error when email is invalid', async () => {
    const wrapper = mount(RegisterForm)

    await wrapper.find('input[type="text"]').setValue('Marcelo')
    await wrapper.find('input[type="email"]').setValue('email_invalido')

    const passwordInputs = wrapper.findAll('input[type="password"]')
    await passwordInputs[0].setValue('123456')
    await passwordInputs[1].setValue('123456')

    await wrapper.find('form').trigger('submit.prevent')

    expect(wrapper.text()).toContain('Email inválido.')
    expect(authService.register).not.toHaveBeenCalled()
  })

  it('shows error when password is shorter than 6 characters', async () => {
    const wrapper = mount(RegisterForm)

    await wrapper.find('input[type="text"]').setValue('Marcelo')
    await wrapper.find('input[type="email"]').setValue('marcelo@email.com')

    const passwordInputs = wrapper.findAll('input[type="password"]')
    await passwordInputs[0].setValue('12345')
    await passwordInputs[1].setValue('12345')

    await wrapper.find('form').trigger('submit.prevent')

    expect(wrapper.text()).toContain('A senha deve ter pelo menos 6 caracteres.')
    expect(authService.register).not.toHaveBeenCalled()
  })

  it('shows error when password confirmation does not match', async () => {
    const wrapper = mount(RegisterForm)

    await wrapper.find('input[type="text"]').setValue('Marcelo')
    await wrapper.find('input[type="email"]').setValue('marcelo@email.com')

    const passwordInputs = wrapper.findAll('input[type="password"]')
    await passwordInputs[0].setValue('123456')
    await passwordInputs[1].setValue('654321')

    await wrapper.find('form').trigger('submit.prevent')

    expect(wrapper.text()).toContain('A confirmação de senha não confere.')
    expect(authService.register).not.toHaveBeenCalled()
  })

  it('emits change-mode when clicking login', async () => {
    const wrapper = mount(RegisterForm)

    await wrapper.find('.auth-link button').trigger('click')

    expect(wrapper.emitted('change-mode')).toBeTruthy()
  })
})