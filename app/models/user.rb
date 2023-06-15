class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.username = "ゲストユーザー"
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def guest?
    email == 'guest@example.com'
  end

  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze

  validates :username, presence: true
  validates :savings_target, numericality: { greater_than_or_equal_to: 0, only_integer: true },
    allow_blank: true
  validates :email, presence: true, uniqueness: true, on: :acount_update
  validates :password, format: { with: VALID_PASSWORD_REGEX, 
    message: "は半角英数を両方含む必要があります" }, 
    confirmation: true, on: :acount_update
  validates :password_confirmation, presence: true, on: :acount_update
end
