class Course < ApplicationRecord
  include Discard::Model

  has_many :memberships
  has_many :users, through: :memberships

  validates :name, presence: true, uniqueness: true

  scope :enabled, -> { where(enabled: true) }

  def self.current
    RequestStore.store[:current_course]
  end

  def self.current=(course)
    RequestStore.store[:current_course] = course
  end
end
