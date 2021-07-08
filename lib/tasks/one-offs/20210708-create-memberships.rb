ActiveRecord::Base.transaction do
  profes = User.where(id: [1, 2, 5])

  Course.where(id: 35..46).each do |course|
    profes.each do |profe|
      Membership.create(course: course, user: profe, enabled: true, role: :teacher)
    end
  end

  Membership.create(course_id: 35, user_id: 148, enabled: true, role: :teacher)
  Membership.create(course_id: 36, user_id: 148, enabled: true, role: :teacher)
  Membership.create(course_id: 37, user_id: 148, enabled: true, role: :teacher)
  Membership.create(course_id: 41, user_id: 1454, enabled: true, role: :teacher)
  Membership.create(course_id: 42, user_id: 1454, enabled: true, role: :teacher)
  Membership.create(course_id: 44, user_id: 724, enabled: true, role: :teacher)
  Membership.create(course_id: 45, user_id: 1455, enabled: true, role: :teacher)
  Membership.create(course_id: 46, user_id: 183, enabled: true, role: :teacher)
end
