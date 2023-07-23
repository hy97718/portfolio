class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :locations, dependent: :destroy
  has_many :incomes, through: :locations, dependent: :destroy
  has_many :expenses, through: :locations, dependent: :destroy
  has_many :dashboards, dependent: :destroy
  has_many :searches

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.username = "ゲストユーザー"
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def guest?
    email == 'guest@example.com'
  end

  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username, presence: true
  validates :savings_target, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_blank: true
  validates :email, { presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } }
  validates :password,
  format: { with: VALID_PASSWORD_REGEX, message: "は半角英数を両方含む必要があります" },
  confirmation: true,
  on: :acount_update
  validates :password_confirmation, presence: true, on: :acount_update
end
