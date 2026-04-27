class ApplicationController < ActionController::API
  before_action :authorize_request

  attr_reader :current_user

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header&.split(' ')&.last

    if token.blank?
      render json: { error: 'Token não informado' }, status: :unauthorized
      return
    end

    decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
    @current_user = User.find(decoded['user_id'])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'Token inválido' }, status: :unauthorized
  end
end