class Course < ApplicationRecord
  include Discard::Model

  has_many :memberships
  has_many :users, through: :memberships

  has_many :events
  has_many :teams

  has_and_belongs_to_many :decks, join_table: :courses_tiny_cards_decks, class_name: "TinyCards::Deck"

  serialize :stats, JSON

  belongs_to :attendance_event, class_name: "Event", foreign_key: "attendance_event_id", optional: true
  belongs_to :parent_course, class_name: "Course", foreign_key: "parent_course_id", optional: true
  has_many :replicas, class_name: "Course", foreign_key: "parent_course_id"

  validates :name, presence: true, uniqueness: true
  validates :password, presence: true

  scope :registrable, -> { where(registrable: true) }

  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }

  def all_events
    inherited = replica ? parent_course.all_events : []
    self.events + inherited
  end

  def template?
    replicas.size > 0
  end

  def editable?
    !replica
  end

  def replicate!
    new_course = nil
    Course.transaction do
      new_course = self.dup
      new_course.rotate_password
      new_course.name = self.name + " " + ("0" + (self.replicas.size + 1).to_s)[-2..-1]
      new_course.save!
    end
    new_course
  end

  def rotate_password
    self.password = open("https://www.dinopass.com/password/simple").read
  end

  def fully_duplicate!
    new_course = nil

    Course.transaction do
      new_course = self.dup
      new_course.rotate_password
      new_course.name = "Copia de " + self.name
      new_course.save!

      old = Course.current
      Course.current = new_course

      Event.unscoped.where(course: self).each do |event|
        new_event = event.dup
        new_event.course = new_course
        new_event.enabled = false
        new_event.save!
      end

      # categories!
      Resource.unscoped.where(course: self).each do |resource|
        new_resource = resource.dup
        new_resource.course = new_course
        current_resource_category = ResourceCategory.unscoped.find(resource.resource_category_id)
        new_resource.resource_category = ResourceCategory.unscoped.find_or_create_by(course: new_course, name: current_resource_category.name)
        new_resource.save!
      end

      due_date_offset = nil
      PeerReview::Challenge.unscoped.where(course: self).order(due_date: :asc).each do |challenge|
        due_date_offset ||= (Time.zone.now.to_date - challenge.due_date).to_i + 30 if challenge.due_date
        new_challenge = challenge.dup
        new_challenge.course = new_course
        new_challenge.enabled = true
        new_challenge.published = false
        new_challenge.awarded = false
        new_challenge.due_date = challenge.due_date + due_date_offset if challenge.due_date
        new_challenge.save!
      end

      Exercise.unscoped.where(course: self).each do |exercise|
        new_exercise = exercise.dup
        new_exercise.notes = exercise.notes
        new_exercise.course = new_course
        new_exercise.published = false
        new_exercise.save!
      end

      # TODO(delucas): left for the next iteration
      # copy automatic correction challenges
      # copy badges
      # copy competences
      # copy cards
      # copy lectures

      MultipleChoices::Questionnaire.unscoped.where(course: self).each do |questionnaire|
        new_questionnaire = questionnaire.dup
        new_questionnaire.course = new_course

        questionnaire.questions.unscoped.where(multiple_choices_questionnaire_id: questionnaire.id).each do |question|
          new_question = question.dup
          question.answers.unscoped.where(multiple_choices_question_id: question.id).each do |answer|
            new_question.answers << answer.dup
          end
          new_questionnaire.questions << new_question
        end

        new_questionnaire.enabled = true
        new_questionnaire.published = false
        new_questionnaire.save!
      end

      new_course.save!

      Course.current = old
    end

    new_course
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
        resources: 1024,
        faqs: 2048
    }
  end

  def switch(user, session)
    user.update(last_visited_course_id: self.id)
    session[:course_id] = self.id
    Course.current = self
  end

  def self.current
    RequestStore.store[:current_course] || NullCourse.new
  end

  def self.current=(course)
    RequestStore.store[:current_course] = course
  end

  def family_ids
    [id] + (replicas.size > 0 ? replicas.map(&:id) : [])
  end

  def students
    users.unscoped.joins(:memberships).where(memberships: { role: :student, course: family_ids }).distinct
  end

  def teachers
    users.includes(:memberships).where(memberships: { course: Course.current, role: :teacher })
  end

  def on?(requested_feature)
    features & Course.all_features[requested_feature] == Course.all_features[requested_feature]
  end
end
