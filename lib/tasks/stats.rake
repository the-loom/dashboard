namespace :stats do
  desc "Precalculates stats for Courses and Teams"
  task calculate: :environment do
    Course.enabled.each do |course|
      Course.current = course
      next unless course.on?(:competences) && CompetenceTag.count > 0
      puts "Precalculating for Course #{course.name}"

      puts "Students for Course #{course.name}"
      course.students.each do |student|
        membership = student.current_membership
        next unless membership || student.team.nil?
        puts "-> Precalculating for Member #{student.full_name}"
        membership.stats = StudentCompetenceTagsStats.new(student).normalized.to_json
        membership.save!
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
