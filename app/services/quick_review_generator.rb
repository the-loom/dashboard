class QuickReviewGenerator
  def self.generate(challenge, current_review)
    notable_reviews = challenge.reviews.final
    notable_reviews += current_review.draft? ? [current_review] : []

    lines = notable_reviews.map do |review|
      to_list(review)
    end.flatten.compact.group_by(&:itself).map do |line, repetitions|
      [repetitions.size, line]
    end.sort_by { |element| element[0] }

    my_reviews = to_list(current_review)

    lines.map do |repetitions_and_line|
      line = repetitions_and_line[1]
      repetitions = repetitions_and_line[0]
      { text: line, checked: current_review.wording && my_reviews.include?(line), percentage: ((repetitions.to_f / notable_reviews.size) * 100).round(2) }
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
