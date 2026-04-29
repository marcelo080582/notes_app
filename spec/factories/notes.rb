FactoryBot.define do
  factory :note do
    title { 'Minha nota' }
    content { 'Conteúdo da nota' }
    association :user
  end
end
