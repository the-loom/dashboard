class QuickReviewGenerator
  def self.generate(challenge, current_review)
    notable_reviews = challenge.reviews.final
    notable_reviews += current_review.draft? ? [current_review] : []

    lines = notable_reviews.map do |review|
      to_list(review)
    end.flatten.compact.group_by(&:itself).map do |line, repetitions|
      [repetitions.size, line]
    end.sort do |x, y|
      y[0] <=> x[0]
    end.map do |repetitions_and_line|
      repetitions_and_line[1]
    end

    my_reviews = to_list(current_review)

    lines.map do |x|
      { text: x, checked: current_review.wording && my_reviews.include?(x) }
    end
  end

  private
    def self.to_list(review)
      if review.wording && !review.wording.empty?
        JSON.parse(review.wording)
      else
        []
      end
    end
end
