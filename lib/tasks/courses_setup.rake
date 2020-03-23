namespace :dev do
  task courses_setup: :environment do
    user = User.last
    Course.all.each do |course|
      Membership.create(
        course: course,
          user: user,
          role: :student,
          enabled: true
      )
    end
  end
end
