class User < ApplicationRecord
  include Discard::Model
  acts_as_voter

  validates_uniqueness_of :uuid

  has_one_attached :avatar

  has_many :memberships, -> { enabled }, dependent: :delete_all
  has_many :all_memberships, class_name: "Membership", foreign_key: :user_id

  has_many :courses, through: :memberships
  has_many :all_courses, through: :all_memberships, source: :course
  belongs_to :last_visited_course, optional: true

  has_many :identities

  has_many :occurrences, -> { order(created_at: :desc) }
  has_many :events, through: :occurrences

  has_many :earnings, -> { order(created_at: :desc) }
  has_many :badges, through: :earnings

  has_many :comments

  has_many :repos, foreign_key: :author_id, class_name: "AutomaticCorrection::Repo"

  has_many :peer_review_solutions, foreign_key: :author_id, class_name: "PeerReview::Solution"
  has_many :peer_review_reviews, foreign_key: :reviewer_id, class_name: "PeerReview::Review"

  validates :avatar, size: { less_than: 500.kilobyte }, content_type: [:png, :jpg, :jpeg]

  def self.to_csv
    CSV.generate do |csv|
      csv << ["Grupo", "Loom ID", "Apellido", "Nombre", "Correo Electrónico", "Presente"]

      enabled_students_for_course = User.includes(:memberships).includes(memberships: :team).where(memberships: { course: Course.current, role: :student, enabled: true }).order("teams.name, last_name, first_name")
      enabled_students_for_course.each do |x|
        team_name = x.current_membership.team.try(:name)
        csv << [team_name, x.uuid.upcase, x.last_name, x.first_name, x.email]
      end
    end
  end

  def points
    current_membership.points
  end

  def refresh_points_cache!
    cm = current_membership
    return unless cm
    cm.points = occurrences.inject(0) { | total, occurrence | total + occurrence.total_points }
    cm.save

    cm.team.refresh_points_cache! if cm.team
  end

  def stats
    current_membership.stats
  end

  def score
    ScoreCalculator.new.score_for(points)
  end

  def short_name
    if last_name.present? && first_name.present?
      "#{first_name.strip} #{last_name[0]}."
    elsif last_name.present?
      last_name.strip
    elsif first_name.present?
      first_name.strip
    else
      "N/A"
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
    @current_membership ||= self.all_memberships.includes([:course]).find { |m| m.course == Course.current }
  end

  def teacher?
    admin? || current_membership.teacher?
  end

  def student?
    current_membership.student?
  end

  def register_attendance(lecture)
    membership = current_membership
    return unless current_membership # TODO: preventive fix, needs re-do
    return unless Course.current.attendance_event # TODO: preventive fix, needs to be handled in a better way
    return if present_at(lecture)
    register(Course.current.attendance_event, 1)

    if membership.present_at_lecture_ids != nil
      membership.present_at_lecture_ids << lecture.id
    else
      membership.present_at_lecture_ids = [lecture.id]
    end
    membership.save
  end

  def register(event, times = 1)
    return unless current_membership && current_membership.enabled? # TODO: preventive fix, needs re-do
    occurrence = occurrences.find_or_initialize_by(event: event)
    occurrence.multiplier = occurrence.new_record? ? times : occurrence.multiplier + times
    occurrence.save

    refresh_points_cache!
  end

  def earn(badge)
    earnings.create(badge: badge)
  end

  # TODO(delucas): move to scope?
  def self.sorted
    self.order(points: :desc)
  end

  # TODO(delucas): move to scope?
  def self.sorted_by_name
    self.order(name: :asc)
  end

  # TODO(delucas): move to presenter
  def present_at(lecture)
    (current_membership.present_at_lecture_ids || []).include? lecture.id
  end

  # TODO(delucas): move to presenter
  def total_attendance
    current_membership.present_at_lecture_ids.try(:size) || 0
  end

  def enabled?
    current_membership && current_membership.enabled?
  end
end
