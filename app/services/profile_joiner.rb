class ProfileJoiner
  def initialize(students)
    @students = students
  end

  def execute
    User.transaction do
      keepable_student = @students.first

      # 1.a joins identities under the first user
      identities = @students.map(&:identities).flatten
      keepable_student.identities << identities

      # 1.b joins memberships under the first user
      courses = @students.map(&:courses).flatten.uniq
      courses.each do |course|
        if keepable_student.memberships.where(course: course).empty?
          keepable_student.memberships << Membership.create(course: course, role: :student)
        end
      end

      deletable_students = @students - [keepable_student]

      deletable_students.each do |deletable_student|
        # remove memberships
        deletable_student.memberships.discard_all

        # reassign solutions
        deletable_student.peer_review_solutions.update_all(author_id: keepable_student.id)

        # reassign reviews
        deletable_student.peer_review_reviews.update_all(reviewer_id: keepable_student.id)

        # discarding users
        deletable_student.discard!
      end

      # TODO(later, if needed)
      # 2. copy points from membership?
      # 3. copy team from membership?
      # 4. copy attendance?
    end

    true
  end
end
