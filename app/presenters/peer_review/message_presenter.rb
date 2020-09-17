class PeerReview::MessagePresenter
  def initialize(message)
    @message = message
  end

  def sender
    @message.user.full_name + (@message.user.teacher? ? " (docente)" : "")
  end

  def created_at
    @message.created_at
  end

  def challenge
    solution.challenge
  end

  def challenge_id
    challenge.id
  end

  def solution
    @message.review.solution
  end

  def reviewee
    solution.author.full_name
  end

  def reviewer
    @message.review.reviewer.full_name
  end

  def content
    @message.content
  end
end
