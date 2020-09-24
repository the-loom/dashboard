class PeerReview::Message < ApplicationRecord
  include CourseLock

  belongs_to :review, foreign_key: :peer_review_review_id
  belongs_to :user

  scope :sorted, -> { order(created_at: :asc) }

  validates_presence_of :content

  def notify!
    challenge = review.challenge
    solution = review.solution
    author = solution.author

    stakeholders = ([author] + review.messages.map(&:user)).uniq - [user]

    stakeholders.each do |stakeholder|
      if stakeholder.teacher?
        Notification.create(subject: "¡Hay un nuevo comentario de #{user.full_name} para '#{challenge.title}' / #{author.full_name}!", author: "Loombot", receiver: stakeholder,
                            text: "Podés verlo aquí <a href='/peer_review/challenges/#{challenge.id}/solutions/#{solution.id}'>aquí</a>")
      else
        Notification.create(subject: "¡Hay un nuevo comentario para '#{challenge.title}'!", author: "Loombot", receiver: stakeholder,
                            text: "Podés verlo aquí <a href='/peer_review/challenges/#{challenge.id}'>aquí</a>")
      end
      stakeholder.current_membership.unread_notifications += 1
      stakeholder.current_membership.save!
    end
  end
end
