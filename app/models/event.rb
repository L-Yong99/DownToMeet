class Event < ApplicationRecord
  # has_many :users, through: :attendances
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  include PgSearch::Model
  multisearchable against: [:name, :category]

  belongs_to :user
  has_many :attendances, dependent: :destroy

  validates :name, :detail, :spots, :address, :date, :time, :private, :category, presence: true
  has_one_attached :photo


end
