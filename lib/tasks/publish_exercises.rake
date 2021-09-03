namespace :exercises do
  desc "Enables current Exercises"
  task publish: :environment do
    Course.enabled.each do |course|
      next unless course.template? || course.unique?
      Course.current = course
      next unless course.on?(:exercises)
      puts "Enabling Exercises for Course #{course.name}"

      Exercise.all.each do |exercise|
        if exercise.current? && !exercise.published?
          exercise.publish!
          puts "-> #{exercise.name} has been enabled"
        end
      end

      puts "Finished enabling for Course #{course.name}"
    end

    puts "Enabling completed"
  end
end
