namespace :notifications do
  desc "Purges old Notifications"
  task purge: :environment do
    Course.enabled.each do |course|
      Course.current = course
      puts "Purging Notifications for Course #{course.name}"

      Notification.all.each do |notification|
        older_than_two_weeks = Time.zone.now > notification.created_at.beginning_of_day + 2.weeks
        if older_than_two_weeks
          # TODO: update notifications counter for each member?
          notification.destroy
        end
      end

      puts "Finished purging for Course #{course.name}"
    end

    puts "Purging completed"
  end
end
