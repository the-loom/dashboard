Course.all.each do | course |
  Course.current = course
  if course.attendance_event != nil
    course.users.each do |user|
      user.lectures.count.times do
        user.register(course.attendance_event)
      end
    end
  end
end
