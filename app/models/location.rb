class Location < ApplicationRecord
  belongs_to :user
  has_many :incomes
  has_many :expenses

  validates :asset_name, presence: true
  validates :location_name, presence: true
end
