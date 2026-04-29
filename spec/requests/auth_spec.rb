require 'rails_helper'

RSpec.describe "Auth", type: :request do
  describe "POST /register" do
    let(:valid_params) do
      {
        name: "Marcelo",
        email: "marcelo@email.com",
        password: "123456",
        password_confirmation: "123456"
      }
    end

    it "creates a user and returns token" do
      post "/register", params: valid_params

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)

      expect(json["token"]).to be_present
      expect(json["user"]["email"]).to eq("marcelo@email.com")
    end

    it "returns error for invalid data" do
      post "/register", params: valid_params.merge(email: "")

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "POST /login" do
    let!(:user) do
      User.create!(
        name: "Marcelo",
        email: "marcelo@email.com",
        password: "123456",
        password_confirmation: "123456"
      )
    end

    it "returns token for valid credentials" do
      post "/login", params: {
        email: user.email,
        password: "123456"
      }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json["token"]).to be_present
    end

    it "returns unauthorized for invalid credentials" do
      post "/login", params: {
        email: user.email,
        password: "wrong"
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
