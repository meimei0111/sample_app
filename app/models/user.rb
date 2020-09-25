class User < ApplicationRecord
  USERS_PARAMS = %i(name email password password_confirmation).freeze
  
  validates :name, presence: true,
    length: { maximum: Settings.validations.name.max_length }
  validates :email, presence: true,
    length: { maximum: Settings.validations.email.max_length },
    format: { with: Settings.validations.email.regex },
    uniqueness: { case_sensitive: true }
  validates :password, presence: true,
    length: { minimum: Settings.validations.password.min_length }
  has_secure_password
  before_save :downcase_email
  
  private 
  
  def downcase_email
    email.downcase!
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end
  end
end
