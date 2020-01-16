ActiveRecord::Base.transaction do
  Course.all.each do |course|
    Course.current = course

    Membership.where(course: course).each do |membership|
      next unless membership.user
      student = membership.user

      lecture_ids = student.attendances.map(&:lecture_id)

      membership.present_at_lecture_ids = lecture_ids
      membership.save
    end
  end
end
