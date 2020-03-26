namespace :dev do
  task teacher_setup: :environment do
    user = User.last
    user.memberships.each do |membership|
      membership.update_attributes(role: :teacher)
    end
  end
end
