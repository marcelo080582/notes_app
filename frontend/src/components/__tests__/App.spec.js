import { mount, flushPromises } from '@vue/test-utils'
import { describe, it, expect, vi, beforeEach } from 'vitest'
import App from '../../App.vue'
import api from '../../services/api'

vi.mock('../../services/api', () => ({
  default: {
    get: vi.fn(),
    post: vi.fn(),
    put: vi.fn(),
    delete: vi.fn()
  }
}))

describe('App', () => {
  beforeEach(() => {
    vi.clearAllMocks()

    window.scrollTo = vi.fn()

    api.get.mockResolvedValue({
      data: {
        notes: [
          {
            id: 1,
            title: 'Nota para editar',
            content: 'Conteúdo da nota'
          }
        ],
        meta: {
          current_page: 1,
          total_pages: 1,
          total_count: 1
        }
      }
    })
  })

  it('renders the application title', async () => {
    const wrapper = mount(App)

    await flushPromises()

    expect(wrapper.text()).toContain('Anotações')
  })

  it('selects a note for editing when edit button is clicked', async () => {
    const wrapper = mount(App)

    await flushPromises()

    await wrapper.find('.edit-btn').trigger('click')

    expect(wrapper.text()).toContain('Editar Nota')
    expect(wrapper.text()).toContain('Editando: Nota para editar')
    expect(wrapper.find('input').element.value).toBe('Nota para editar')
    expect(wrapper.find('textarea').element.value).toBe('Conteúdo da nota')
  })

  it('cancels editing mode', async () => {
    const wrapper = mount(App)

    await flushPromises()

    await wrapper.find('.edit-btn').trigger('click')

    expect(wrapper.text()).toContain('Editando: Nota para editar')

    await wrapper.find('.editing-info button').trigger('click')

    expect(wrapper.text()).toContain('Criar Nota')
    expect(wrapper.text()).not.toContain('Editando: Nota para editar')
    expect(wrapper.find('input').element.value).toBe('')
    expect(wrapper.find('textarea').element.value).toBe('')
  })
})