class User < ApplicationRecord
  validates_uniqueness_of :uuid

  has_one_attached :avatar

  has_many :memberships, -> { enabled }, dependent: :delete_all
  has_many :all_memberships, class_name: "Membership", foreign_key: :user_id

  has_many :courses, through: :memberships
  has_many :all_courses, through: :all_memberships, source: :course

  has_many :identities

  has_many :occurrences, -> { order(created_at: :desc) }
  has_many :events, through: :occurrences

  has_many :earnings, -> { order(created_at: :desc) }
  has_many :badges, through: :earnings

  has_many :attendances
  has_many :lectures, through: :attendances

  has_many :comments

  has_many :user_solutions
  has_many :solutions, through: :user_solutions

  has_many :repos, foreign_key: :author_id, class_name: "AutomaticCorrection::Repo"

  has_many :peer_review_solutions, foreign_key: :author_id, class_name: "PeerReview::Solution"

  def points
    events.inject(0) { | total, event | total + event.points }
  end

  def stats
    ::StudentCompetenceTagsStats.new(self)
  end

  def score
    min = Event.min_points
    max = Event.max_points
    spread = max - min
    pts = points
    normalized = pts - min
    if pts < min
      2.0
    elsif pts > max
      10.0
    else
      (normalized.to_f / spread) * 6 + 4
    end
  end

  def full_name
    if last_name.present? && first_name.present?
      "#{last_name.strip}, #{first_name.strip}"
    elsif last_name.present?
      last_name.strip
    elsif first_name.present?
      first_name.strip
    else
      "N/A"
    end
  end

  def enabled_memberships
    memberships.joins(:course).where(courses: { enabled: true })
  end

  def has_github_identity?
    identities.exists?(provider: "github")
  end

  def has_pending_correction_on?(repo)
    repos.exists?(pending: true, id: repo.forks.pluck(:id))
  end

  def github_username
    identities.find_by(provider: "github").nickname
  end

  def update_with(identity)
    self.nickname = identity.nickname
    self.first_name = identity.first_name unless self.first_name.present?
    self.last_name = identity.last_name unless self.last_name.present?
    self.email = identity.email
    self.image = identity.image
    self.save
    self
  end

  def current_membership
    self.all_memberships.find_by(course: Course.current)
  end

  def teacher?
    current_membership.teacher? || current_membership.admin?
  end

  def student?
    current_membership.student?
  end

  def register_attendance(lecture, condition)
    return unless current_membership # TODO: preventive fix, needs re-do
    return unless Course.current.attendance_event # TODO: preventive fix, needs to be handled in a better way
    return if present_at(lecture)
    if condition == :present
      register(Course.current.attendance_event)
    end
    attendance = Attendance.find_or_create_by(user: self, lecture: lecture)
    attendance.update_attributes(condition: condition)
  end

  def register(event)
    return unless current_membership && current_membership.enabled? # TODO: preventive fix, needs re-do
    occurrences.create(event: event, points: event.points)
  end

  def earn(badge)
    earnings.create(badge: badge)
  end

  def self.sorted
    self.order(points: :desc)
  end

  def self.sorted_by_name
    self.order(name: :asc)
  end

  def present_at(lecture)
    attendances.where(lecture: lecture, condition: :present).size > 0
  end

  def enabled?
    current_membership && current_membership.enabled?
  end
end
