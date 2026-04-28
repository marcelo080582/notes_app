require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with name, email and password' do
    user = User.new(
      name: 'Marcelo',
      email: 'marcelo@email.com',
      password: '123456',
      password_confirmation: '123456'
    )

    expect(user).to be_valid
  end

  it 'is invalid without name' do
    user = User.new(
      name: nil,
      email: 'marcelo@email.com',
      password: '123456',
      password_confirmation: '123456'
    )

    expect(user).not_to be_valid
  end

  it 'is invalid without email' do
    user = User.new(
      name: 'Marcelo',
      email: nil,
      password: '123456',
      password_confirmation: '123456'
    )

    expect(user).not_to be_valid
  end

  it 'is invalid with invalid email format' do
    user = User.new(
      name: 'Marcelo',
      email: 'email_invalido',
      password: '123456',
      password_confirmation: '123456'
    )

    expect(user).not_to be_valid
  end

  it 'is valid with valid email format' do
    user = User.new(
      name: 'Marcelo',
      email: 'marcelo@email.com',
      password: '123456',
      password_confirmation: '123456'
    )

    expect(user).to be_valid
  end

  it 'is invalid with duplicated email' do
    create(:user, email: 'marcelo@email.com')

    user = User.new(
      name: 'Outro usuário',
      email: 'marcelo@email.com',
      password: '123456',
      password_confirmation: '123456'
    )

    expect(user).not_to be_valid
  end

  it 'is invalid with password shorter than 6 characters' do
    user = User.new(
      name: 'Marcelo',
      email: 'marcelo@email.com',
      password: '12345',
      password_confirmation: '12345'
    )

    expect(user).not_to be_valid
  end

  it 'is invalid when password confirmation does not match' do
    user = User.new(
      name: 'Marcelo',
      email: 'marcelo@email.com',
      password: '123456',
      password_confirmation: '654321'
    )

    expect(user).not_to be_valid
  end

  it 'has many notes' do
    association = described_class.reflect_on_association(:notes)

    expect(association.macro).to eq(:has_many)
    expect(association.options[:dependent]).to eq(:destroy)
  end
end