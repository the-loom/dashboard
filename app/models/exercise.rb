class Exercise < ApplicationRecord
  include CourseLock
  include Publishable

  validates_presence_of :name, :notes, :difficulty
  validates :name, uniqueness: { scope: :course_id }
  validate :difficulty_range

  def difficulty_range
    if difficulty.present? and (difficulty < 1 or difficulty > 5)
      errors.add(:difficulty, "cannot be less than 1 or greater than 5")
    end
  end

  default_scope { order(name: :asc) }
  scope :published, -> { where(published: true) }
end
