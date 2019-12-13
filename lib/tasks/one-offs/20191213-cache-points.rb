ActiveRecord::Base.transaction do

  Course.all.each do |course|
    Course.current = course

    course.memberships.each do |membership|
      next unless membership.user
      student = membership.user
      student.refresh_points_cache!
    end
  end
end
