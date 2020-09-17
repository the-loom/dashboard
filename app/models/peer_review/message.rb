class PeerReview::Message < ApplicationRecord
  include CourseLock

  belongs_to :review, foreign_key: :peer_review_review_id
  belongs_to :user

  scope :sorted, -> { order(created_at: :asc) }

  validates_presence_of :content

  def notify!
    challenge = review.challenge
    author = review.solution.author
    return if author == user
    Notification.create(subject: "¡Hay un nuevo comentario para '#{challenge.title}'!", author: "Loombot", receiver: author,
                        text: "Podés verlo aquí <a href='/peer_review/challenges/#{challenge.id}'>aquí</a>")
    author.current_membership.unread_notifications += 1
    author.current_membership.save!
  end
end
