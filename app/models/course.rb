class Course < ApplicationRecord
  include Discard::Model

  has_many :memberships
  has_many :users, through: :memberships

  has_many :events
  has_many :teams

  serialize :stats, JSON

  belongs_to :attendance_event, class_name: "Event", foreign_key: "attendance_event_id", optional: true

  validates :name, presence: true, uniqueness: true
  validates :password, presence: true

  scope :enabled, -> { where(enabled: true) }

  def self.current
    RequestStore.store[:current_course]
  end

  def self.current=(course)
    RequestStore.store[:current_course] = course
  end

  def on?(requested_feature)
    all_features = {
        badges: 1,
        events: 2,
        teams: 4,
        lectures: 8,
        automatic_correction_challenges: 16,
        peer_review_challenges: 32,
        exercises: 64,
        competences: 128
    }

    features & all_features[requested_feature] == all_features[requested_feature]
  end

end
