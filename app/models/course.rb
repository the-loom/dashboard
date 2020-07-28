class Course < ApplicationRecord
  include Discard::Model

  has_many :memberships
  has_many :users, through: :memberships

  has_many :events
  has_many :teams

  has_and_belongs_to_many :decks, join_table: :courses_tiny_cards_decks, class_name: "TinyCards::Deck"

  serialize :stats, JSON

  belongs_to :attendance_event, class_name: "Event", foreign_key: "attendance_event_id", optional: true

  validates :name, presence: true, uniqueness: true
  validates :password, presence: true

  scope :enabled, -> { where(enabled: true) }

  def fully_duplicate!
    copy = self.dup
    copy.name = "Copia de " + self.name

    Event.unscoped.where(course: self).each do |event|
      e2 = event.dup
      e2.course = copy
      e2.enabled = false
      e2.save
    end

    # categories!
    Resource.unscoped.where(course: self).each do |res|
      r2 = res.dup
      r2.course = copy
      r2.resource_category = ResourceCategory.unscoped.find_or_create_by(course: copy, name: res.resource_category.name)
      r2.save
    end

    offset = nil
    PeerReview::Challenge.unscoped.where(course: self).order(due_date: :asc).each do |ch|
      ch2 = ch.dup
      ch2.course = copy
      ch2.enabled = false
      offset = (Time.zone.now.to_date - ch.due_date).to_i + 30 unless offset
      ch2.due_date = ch.due_date + offset
      ch2.save
    end

    Exercise.unscoped.where(course: self).each do |exer|
      e2 = exer.dup
      e2.course = copy
      e2.published = false
      e2.save
    end

    # TODO(delucas): left for the next iteration
    # copy automatic correction challenges
    # copy badges
    # copy competences
    # copy cards
    # copy lectures
    # copy multiple choices

    copy.save!
    copy
  end

  def self.all_features
    {
        badges: 1,
        events: 2,
        teams: 4,
        lectures: 8,
        automatic_correction_challenges: 16,
        peer_review_challenges: 32,
        exercises: 64,
        competences: 128,
        tiny_cards: 256,
        multiple_choices: 512,
        resources: 1024
    }
  end

  def self.current
    RequestStore.store[:current_course]
  end

  def self.current=(course)
    RequestStore.store[:current_course] = course
  end

  def students
    users.joins(:memberships).where(memberships: { role: :student, course: Course.current }).distinct
  end

  def on?(requested_feature)
    features & Course.all_features[requested_feature] == Course.all_features[requested_feature]
  end
end
