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
end