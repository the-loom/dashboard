namespace :challenges do
  desc "Publishes current PeerReview::Challenges"
  task publish: :environment do
    Course.enabled.each do |course|
      next unless course.template? || course.unique?
      Course.current = course
      next unless course.on?(:peer_review_challenges)
      puts "Publishing Challenges for Course #{course.name}"

      PeerReview::Challenge.all.each do |challenge|
        if challenge.current? && !challenge.published?
          challenge.publish!
          puts "-> #{challenge.title} has been published"
        end
      end

      puts "Finished publishing for Course #{course.name}"
    end

    puts "Publishing completed"
  end
end
