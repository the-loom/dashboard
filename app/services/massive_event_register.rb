class MassiveEventRegister

  def initialize(students, event, multiplier, lecture)
    @students = students
    @event = event
    @multiplier = multiplier
    @lecture = lecture
  end

  def execute
    @students.each do |student|
      if @lecture == nil || student.present_at(@lecture)
        @multiplier.times do
          student.register(@event)
        end
      end
    end

    true
  end
end
