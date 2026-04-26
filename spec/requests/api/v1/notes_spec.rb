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

    context 'when searching notes' do
      let!(:motor_note) do
        create(:note, title: 'Motor danificado', content: 'Problema no veículo')
      end

      let!(:pintura_note) do
        create(:note, title: 'Pintura', content: 'Serviço de pintura automotiva')
      end

      let!(:cafe_note) do
        create(:note, title: 'Café da manhã', content: 'Anotação com acento')
      end

      it 'returns notes matching the title' do
        get '/api/v1/notes', params: { q: 'motor' }

        json = JSON.parse(response.body)
        titles = json['notes'].map { |note| note['title'] }

        expect(response).to have_http_status(:ok)
        expect(titles).to include('Motor danificado')
        expect(titles).not_to include('Pintura')
      end

      it 'returns notes matching the content' do
        get '/api/v1/notes', params: { q: 'pintura' }

        json = JSON.parse(response.body)
        titles = json['notes'].map { |note| note['title'] }

        expect(response).to have_http_status(:ok)
        expect(titles).to include('Pintura')
        expect(titles).not_to include('Motor danificado')
      end

      it 'returns notes ignoring accents' do
        get '/api/v1/notes', params: { q: 'cafe' }

        json = JSON.parse(response.body)
        titles = json['notes'].map { |note| note['title'] }

        expect(response).to have_http_status(:ok)
        expect(titles).to include('Café da manhã')
      end
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

    context 'when note does not exist' do
      it 'returns not found' do
        patch '/api/v1/notes/999999', params: {
          note: {
            title: 'Título atualizado',
            content: 'Conteúdo atualizado'
          }
        }

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('Nota não encontrada')
      end
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

    context 'when note does not exist' do
      it 'returns not found' do
        delete '/api/v1/notes/999999'

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('Nota não encontrada')
      end
    end
  end
end