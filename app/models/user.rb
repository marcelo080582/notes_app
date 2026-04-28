class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP

  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true

  has_many :notes, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end