class ProfileJoiner
  def initialize(students)
    @students = students
  end

  def execute
    @students.each do |student|
      student.earn(@badge)
    end

    student = @students.first

    # 1. joins identities under the first user
    identities = @students.map(&:identities).flatten
    student.identities << identities

    (@students - [student]).each do |s|
      s.destroy
    end

    # TODO(later, if needed)
    # 2. copy points from membership?
    # 3. copy team from membership?
    # 4. copy attendance?

    true
  end
end
