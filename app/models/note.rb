class Note < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, length: { maximum: 1000 }, allow_blank: true

  scope :search_by_term, lambda { |term|
    return all if term.blank?

    sanitized_query = ActiveRecord::Base.sanitize_sql_like(term)
    search_term = "%#{sanitized_query}%"

    where(
      'unaccent(title) ILIKE unaccent(:search) OR unaccent(content) ILIKE unaccent(:search)',
      search: search_term
    )
  }
end