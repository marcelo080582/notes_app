import { mount } from '@vue/test-utils'
import { describe, it, expect, vi, beforeEach } from 'vitest'
import NoteForm from '../NoteForm.vue'
import api from '../../services/api'

vi.mock('../../services/api', () => ({
  default: {
    post: vi.fn(),
    put: vi.fn()
  }
}))

describe('NoteForm', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('shows validation error when title is blank', async () => {
    const wrapper = mount(NoteForm)

    await wrapper.find('form').trigger('submit.prevent')

    expect(wrapper.text()).toContain('Título é obrigatório')
    expect(api.post).not.toHaveBeenCalled()
  })

  it('creates a note successfully', async () => {
    api.post.mockResolvedValue({ data: { id: 1 } })

    const wrapper = mount(NoteForm)

    await wrapper.find('input').setValue('Minha nota')
    await wrapper.find('textarea').setValue('Conteúdo da nota')
    await wrapper.find('form').trigger('submit.prevent')

    expect(api.post).toHaveBeenCalledWith('/notes', {
      note: {
        title: 'Minha nota',
        content: 'Conteúdo da nota'
      }
    })

    expect(wrapper.emitted('note-created')).toBeTruthy()
  })

  it('fills the form when editing a note', () => {
    const wrapper = mount(NoteForm, {
      props: {
        note: {
          id: 1,
          title: 'Nota existente',
          content: 'Conteúdo existente'
        }
      }
    })

    expect(wrapper.find('input').element.value).toBe('Nota existente')
    expect(wrapper.find('textarea').element.value).toBe('Conteúdo existente')
    expect(wrapper.text()).toContain('Editar Nota')
  })

  it('updates a note successfully', async () => {
    api.put.mockResolvedValue({ data: { id: 1 } })

    const wrapper = mount(NoteForm, {
      props: {
        note: {
          id: 1,
          title: 'Nota antiga',
          content: 'Conteúdo antigo'
        }
      }
    })

    await wrapper.find('input').setValue('Nota atualizada')
    await wrapper.find('textarea').setValue('Conteúdo atualizado')
    await wrapper.find('form').trigger('submit.prevent')

    expect(api.put).toHaveBeenCalledWith('/notes/1', {
      note: {
        title: 'Nota atualizada',
        content: 'Conteúdo atualizado'
      }
    })

    expect(wrapper.emitted('note-updated')).toBeTruthy()
  })

  it('sets max length for title field', () => {
    const wrapper = mount(NoteForm)

    expect(wrapper.find('input').attributes('maxlength')).toBe('100')
  })

  it('sets max length for content field', () => {
    const wrapper = mount(NoteForm)

    expect(wrapper.find('textarea').attributes('maxlength')).toBe('1000')
  })
})