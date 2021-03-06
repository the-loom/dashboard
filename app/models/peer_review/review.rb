class PeerReview::Review < ApplicationRecord
  include CourseLock
  belongs_to :solution, foreign_key: :peer_review_solution_id
  delegate :challenge, to: :solution
  belongs_to :reviewer, foreign_key: :reviewer_id, class_name: "User"

  has_many :messages, foreign_key: :peer_review_review_id, dependent: :delete_all

  validates :solution, uniqueness: { scope: :reviewer, message: "should review only once per solution" }

  enum status: {
      draft: 0,
      final: 1
  }

  serialize :rubrics, JSON

  scope :sorted, -> { order(id: :asc) }
  scope :by, ->(user) { where(reviewer: user) }

  def publish!
    self.status = :final
  end

  def notify!
    Notification.create(subject: "¡Hay una nueva revisión para '#{challenge.title}'!", author: "Loombot", receiver: solution.author,
                        text: "Podés ver tu revisión <a href='/peer_review/challenges/#{challenge.id}'>aquí</a>")
    solution.author.current_membership.unread_notifications += 1
    solution.author.current_membership.save!
  end
end
