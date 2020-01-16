namespace :stats do
  desc "Precalculates stats for Courses and Teams"
  task calculate: :environment do
    Course.all.each do |course|
      Course.current = course
      next unless course.on?(:competences)
      puts "Precalculating for Course #{course.name}"

      puts "Students for Course #{course.name}"
      course.users.each do |student|
        next unless student.current_membership
        puts "-> Precalculating for Member #{student.full_name}"
        student.current_membership.stats = StudentCompetenceTagsStats.new(student).normalized.to_json
        student.current_membership.save!
      end

      puts "Teams for Course #{course.name}"
      course.teams.each do |team|
        puts "-> Precalculating for Team #{team.name}"
        team.stats = TeamCompetenceTagsStats.new(team).normalized.to_json
        team.save!
      end

      course.stats = CourseCompetenceTagsStats.new(course).normalized.to_json
      course.save!

      puts "Finished precalculating for Course #{course.name}"
    end

    puts "Cache completed."
  end
end
