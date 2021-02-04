namespace :usernames do
  desc "Updates user first and last name for all users"
  task fix: :environment do
    def sanitize(name)
      return "" unless name
      name.strip.split.map(&:capitalize).join(" ")
    end

    User.all.each do |user|
      user.first_name = sanitize(user.first_name)
      user.last_name = sanitize(user.last_name)
      user.save
    end

    puts "First/last name update completed"
  end
end
