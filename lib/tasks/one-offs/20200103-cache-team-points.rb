ActiveRecord::Base.transaction do
  Course.all.each do |course|
    Course.current = course
    Team.all.tap(&:refresh_points_cache!)
  end
end
