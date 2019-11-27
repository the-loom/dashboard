namespace :stats do
  desc "Precalculates stats for Courses and Teams"
  task calculate: :environment do

    Course.all.each do |course|
      Course.current = course
      next unless course.on?(:competences)
      puts "Precalculating for #{course.name}"

      course.stats = CourseCompetenceTagsStats.new(course).normalized.to_json
      course.save!

      course.teams.each do |team|
        puts "-> Precalculating for #{team.name}"
        team.stats = TeamCompetenceTagsStats.new(team).normalized.to_json
        team.save!
      end
    end

    puts "Cache completed."
  end
end
