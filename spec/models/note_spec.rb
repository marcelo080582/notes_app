require 'rails_helper'

RSpec.describe Note, type: :model do
  it 'is valid with title and content' do
    note = Note.new(title: 'Título', content: 'Conteúdo')
    expect(note).to be_valid
  end

  it 'is valid without content' do
    note = Note.new(title: 'Título')
    expect(note).to be_valid
  end

  it 'is invalid without title' do
    note = Note.new(title: nil)
    expect(note).not_to be_valid
  end

  it 'is invalid when title is too long' do
    note = Note.new(title: 'a' * 101)
    expect(note).not_to be_valid
  end

  it 'is invalid when content is too long' do
    note = Note.new(title: 'Título', content: 'a' * 1001)
    expect(note).not_to be_valid
  end

  describe '.search_by_term' do
    let!(:motor_note) do
      create(:note, title: 'Motor', content: 'Problema')
    end

    let!(:pintura_note) do
      create(:note, title: 'Pintura', content: 'Serviço')
    end

    let!(:cafe_note) do
      create(:note, title: 'Café', content: 'Anotação com acento')
    end

    it 'returns notes matching the title' do
      result = Note.search_by_term('motor')

      expect(result).to include(motor_note)
      expect(result).not_to include(pintura_note)
    end

    it 'returns notes matching the content' do
      result = Note.search_by_term('serviço')

      expect(result).to include(pintura_note)
      expect(result).not_to include(motor_note)
    end

    it 'returns notes ignoring accents' do
      result = Note.search_by_term('cafe')

      expect(result).to include(cafe_note)
    end

    it 'returns all notes when query is blank' do
      result = Note.search_by_term('')

      expect(result).to include(motor_note, pintura_note, cafe_note)
    end
  end
end