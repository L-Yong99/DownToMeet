class Event < ApplicationRecord
  # has_many :users, through: :attendances
  belongs_to :user
  has_many :attendances, dependent: :destroy

  validates :name, :detail, :spots, :address, :date, :time, :private, :category, presence: true
  has_many_attached :photos
end
