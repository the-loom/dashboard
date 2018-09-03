class MassiveBadgeAssigner
  def initialize(students, badge)
    @students = students
    @badge = badge
  end

  def execute
    @students.each do |student|
      student.earn(@badge)
    end

    true
  end
end
