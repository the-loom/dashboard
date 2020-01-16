class Badge < ApplicationRecord
  include CourseLock

  has_one_attached :image
  has_many :earnings
  has_many :users, through: :earnings

  validates_presence_of :name, :description
  validates :name, uniqueness: { scope: :course_id }
  validates :image, size: { less_than: 500.kilobyte }, content_type: [:png, :jpg, :jpeg]
end
