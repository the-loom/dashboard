class PeerReview::FlowOverviewPresenter
  attr_reader :matrix

  def initialize(reviews)
    @relevant_data = reviews.map { |r| { reviewer: r.reviewer, reviewee: r.solution.author } }
    @relevant_data.select! { |r| !(r[:reviewer].nil? || r[:reviewee].nil?) }
    @reviewers = @relevant_data.group_by { |r| r[:reviewer] }.sort { |r1, r2| r2[1].size <=> r1[1].size }.map { |x| x[0] }

    @matrix = @reviewers.map do |reviewer|
      @reviewers.map do |reviewee|
        @relevant_data.select { |r| r[:reviewer].id == reviewer.id && r[:reviewee].id == reviewee.id }.count
      end
    end
  end

  def has_teacher_reviews?
    !teacher_reviews.empty?
  end

  def has_student_reviews?
    !student_reviews.empty?
  end

  def has_flow?
    has_student_reviews?
  end

  def reviewers
    @reviewers.map do |r|
      { name: r.full_name, color: r.teacher? ? "#FF0000" : "#" + ("%06x" % (rand * 0x00ffff)) }
    end
  end

  def teacher_reviews
    @teacher_reviews ||= @reviewers.select { |r| r.teacher? }.map do |teacher|
      [teacher.full_name, @relevant_data.select { |r| r[:reviewer] == teacher }.size ]
    end
  end

  def student_reviews
    @student_reviews ||= begin
      partial = @reviewers.select { |r| r.student? }.map do |teacher|
        [teacher.full_name, @relevant_data.select { |r| r[:reviewer] == teacher }.size ]
      end
      others = partial.empty? || partial.size < 10 ? [] : [["Otros", (partial[9..-1].sum { |x| x[1] })]]
      partial[0..9] + others
    end
  end
end
