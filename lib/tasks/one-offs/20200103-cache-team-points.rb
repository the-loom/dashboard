ActiveRecord::Base.transaction do

  Course.all.each do |course|
    Course.current = course

    Team.all.each do |team|
      team.refresh_points_cache!
    end
  end
end
