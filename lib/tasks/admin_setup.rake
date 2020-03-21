namespace :dev do  
    task admin_setup: :environment do
      user = User.last
      user.update admin: true
    end
end
