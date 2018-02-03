class Course < ApplicationRecord
  
  has_many :memberships
  has_many :users, through: :memberships

  validates :name, presence: true, uniqueness: true

  def self.current
    RequestStore.store[:current_course]
  end

  def self.current=(course)
    RequestStore.store[:current_course] = course
  end

end
