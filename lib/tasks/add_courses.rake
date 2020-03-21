namespace :dev do  
    task add_courses: :environment do
      user = User.find_by(admin: true)
      Course.all.each do |course|
        Membership.create(
          course: course,
          role: :teacher,
          user: user,
          enabled: true
        )
      end
    end
end
