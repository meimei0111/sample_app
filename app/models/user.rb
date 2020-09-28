class User < ApplicationRecord
  attr_accessor :remember_token

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
  
  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def authenticated? remember_token
    return false unless remember_digest
    
    BCrypt::Password.new(remember_digest).is_password? remember_token

  private 
  
  def downcase_email
    email.downcase!
  end
end
