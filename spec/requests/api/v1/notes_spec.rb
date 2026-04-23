require 'rails_helper'

RSpec.describe 'Api::V1::Notes', type: :request do
  describe 'GET /api/v1/notes' do
    it 'returns notes paginated' do
      create_list(:note, 25)

      get '/api/v1/notes'

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json['notes'].size).to eq(20)
      expect(json['meta']['total_count']).to eq(25)
    end
  end

  describe 'POST /api/v1/notes' do
    it 'creates a note' do
      expect {
        post '/api/v1/notes', params: {
          note: { title: 'Nova nota', content: 'Conteúdo' }
        }
      }.to change(Note, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it 'returns validation errors' do
      post '/api/v1/notes', params: {
        note: { title: '', content: 'Conteúdo' }
      }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'PATCH /api/v1/notes/:id' do
    it 'updates a note' do
      note = create(:note, title: 'Antigo')

      patch "/api/v1/notes/#{note.id}", params: {
        note: { title: 'Atualizado' }
      }

      expect(response).to have_http_status(:ok)
      expect(note.reload.title).to eq('Atualizado')
    end
  end

  describe 'DELETE /api/v1/notes/:id' do
    it 'deletes a note' do
      note = create(:note)

      expect {
        delete "/api/v1/notes/#{note.id}"
      }.to change(Note, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end