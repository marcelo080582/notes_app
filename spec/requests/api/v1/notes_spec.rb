require 'rails_helper'

RSpec.describe 'Api::V1::Notes', type: :request do
  let(:user) { create(:user) }

  let(:token) do
    JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base)
  end

  let(:headers) do
    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /api/v1/notes' do
    it 'returns notes paginated' do
      create_list(:note, 25, user: user)

      get '/api/v1/notes', headers: headers

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json['notes'].size).to eq(5)
      expect(json['meta']['total_count']).to eq(25)
    end

    it 'returns only notes from authenticated user' do
      other_user = create(:user)

      user_note = create(:note, title: 'Minha nota', user: user)
      create(:note, title: 'Nota de outro usuário', user: other_user)

      get '/api/v1/notes', headers: headers

      json = JSON.parse(response.body)
      titles = json['notes'].map { |note| note['title'] }

      expect(response).to have_http_status(:ok)
      expect(titles).to include(user_note.title)
      expect(titles).not_to include('Nota de outro usuário')
    end

    context 'when searching notes' do
      let!(:motor_note) do
        create(:note, title: 'Motor danificado', content: 'Problema no veículo', user: user)
      end

      let!(:pintura_note) do
        create(:note, title: 'Pintura', content: 'Serviço de pintura automotiva', user: user)
      end

      let!(:cafe_note) do
        create(:note, title: 'Café da manhã', content: 'Anotação com acento', user: user)
      end

      it 'returns notes matching the title' do
        get '/api/v1/notes', params: { q: 'motor' }, headers: headers

        json = JSON.parse(response.body)
        titles = json['notes'].map { |note| note['title'] }

        expect(response).to have_http_status(:ok)
        expect(titles).to include('Motor danificado')
        expect(titles).not_to include('Pintura')
      end

      it 'returns notes matching the content' do
        get '/api/v1/notes', params: { q: 'pintura' }, headers: headers

        json = JSON.parse(response.body)
        titles = json['notes'].map { |note| note['title'] }

        expect(response).to have_http_status(:ok)
        expect(titles).to include('Pintura')
        expect(titles).not_to include('Motor danificado')
      end

      it 'returns notes ignoring accents' do
        get '/api/v1/notes', params: { q: 'cafe' }, headers: headers

        json = JSON.parse(response.body)
        titles = json['notes'].map { |note| note['title'] }

        expect(response).to have_http_status(:ok)
        expect(titles).to include('Café da manhã')
      end
    end
  end

  describe 'POST /api/v1/notes' do
    it 'creates a note for authenticated user' do
      expect {
        post '/api/v1/notes',
             params: {
               note: { title: 'Nova nota', content: 'Conteúdo' }
             },
             headers: headers
      }.to change(Note, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(Note.last.user).to eq(user)
    end

    it 'returns validation errors' do
      post '/api/v1/notes', params: {
        note: { title: '', content: 'Conteúdo' }
      },
      headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'PATCH /api/v1/notes/:id' do
    it 'updates a note from authenticated user' do
      note = create(:note, title: 'Antigo', user: user)

      patch "/api/v1/notes/#{note.id}", params: {
        note: { title: 'Atualizado' }
      },
      headers: headers

      expect(response).to have_http_status(:ok)
      expect(note.reload.title).to eq('Atualizado')
    end

    it 'does not update note from another user' do
      other_user = create(:user)
      note = create(:note, title: 'Nota de outro usuário', user: other_user)

      patch "/api/v1/notes/#{note.id}", params: {
        note: { title: 'Tentativa de alteração' }
      },
      headers: headers

      expect(response).to have_http_status(:not_found)
      expect(note.reload.title).to eq('Nota de outro usuário')
    end

    context 'when note does not exist' do
      it 'returns not found' do
        patch '/api/v1/notes/999999', params: {
          note: {
            title: 'Título atualizado',
            content: 'Conteúdo atualizado'
          }
        },
        headers: headers

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('Nota não encontrada')
      end
    end
  end

  describe 'DELETE /api/v1/notes/:id' do
    it 'deletes a note from authenticated user' do
      note = create(:note, user: user)

      expect {
        delete "/api/v1/notes/#{note.id}", headers: headers
      }.to change(Note, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it 'does not delete note from another user' do
      other_user = create(:user)
      note = create(:note, user: other_user)

      expect {
        delete "/api/v1/notes/#{note.id}", headers: headers
      }.not_to change(Note, :count)

      expect(response).to have_http_status(:not_found)
    end

    context 'when note does not exist' do
      it 'returns not found' do
        delete '/api/v1/notes/999999', headers: headers

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('Nota não encontrada')
      end
    end
  end

  describe 'Authorization' do
    it 'returns unauthorized when token is missing' do
      get '/api/v1/notes'

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unauthorized)
      expect(json['error']).to eq('Token não informado')
    end

    it 'returns unauthorized with invalid token' do
      invalid_headers = { 'Authorization' => 'Bearer invalid_token' }

      get '/api/v1/notes', headers: invalid_headers

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unauthorized)
      expect(json['error']).to eq('Token inválido')
    end
  end
end