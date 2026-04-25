import { mount } from '@vue/test-utils'
import { describe, it, expect, vi, beforeEach } from 'vitest'
import NoteList from '../NoteList.vue'
import api from '../../services/api'

vi.mock('../../services/api', () => ({
  default: {
    get: vi.fn(),
    delete: vi.fn()
  }
}))

describe('NoteList', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('fetches and displays notes', async () => {
    api.get.mockResolvedValue({
      data: {
        notes: [{ id: 1, title: 'Nota 1', content: 'Conteúdo' }],
        meta: { current_page: 1, total_pages: 1 }
      }
    })

    const wrapper = mount(NoteList)

    await new Promise(resolve => setTimeout(resolve, 0))

    expect(api.get).toHaveBeenCalled()
    expect(wrapper.text()).toContain('Nota 1')
  })

  it('shows empty state when no notes', async () => {
    api.get.mockResolvedValue({
      data: {
        notes: [],
        meta: { current_page: 1, total_pages: 1 }
      }
    })

    const wrapper = mount(NoteList)

    await new Promise(resolve => setTimeout(resolve, 0))

    expect(wrapper.text()).toContain('Nenhuma anotação encontrada')
  })

  it('searches notes when typing', async () => {
    api.get.mockResolvedValue({
      data: {
        notes: [],
        meta: { current_page: 1, total_pages: 1 }
      }
    })

    const wrapper = mount(NoteList)

    await wrapper.find('input').setValue('motor')

    await new Promise(resolve => setTimeout(resolve, 500))

    expect(api.get).toHaveBeenLastCalledWith('/notes', {
      params: { page: 1, q: 'motor' }
    })
  })

  it('emits edit event', async () => {
    api.get.mockResolvedValue({
      data: {
        notes: [{ id: 1, title: 'Nota', content: '' }],
        meta: { current_page: 1, total_pages: 1 }
      }
    })

    const wrapper = mount(NoteList)

    await new Promise(resolve => setTimeout(resolve, 0))

    await wrapper.find('.edit-btn').trigger('click')

    expect(wrapper.emitted('edit-note')).toBeTruthy()
  })

  it('deletes a note', async () => {
    window.confirm = vi.fn(() => true)

    api.get.mockResolvedValue({
      data: {
        notes: [{ id: 1, title: 'Nota', content: '' }],
        meta: { current_page: 1, total_pages: 1 }
      }
    })

    api.delete.mockResolvedValue({})

    const wrapper = mount(NoteList)

    await new Promise(resolve => setTimeout(resolve, 0))

    await wrapper.find('.delete-btn').trigger('click')

    expect(api.delete).toHaveBeenCalledWith('/notes/1')
  })
})