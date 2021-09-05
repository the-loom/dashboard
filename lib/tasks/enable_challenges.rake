namespace :challenges do
  desc "Enables current PeerReview::Challenges"
  task enable: :environment do
    Course.enabled.each do |course|
      next unless course.template? || course.unique?
      Course.current = course
      next unless course.on?(:peer_review_challenges)
      puts "Enabling Challenges for Course #{course.name}"

      PeerReview::Challenge.all.each do |challenge|
        if challenge.current? && !challenge.enabled?
          challenge.enable!
          puts "-> #{challenge.title} has been enabled"
        end
      end

      puts "Finished enabling for Course #{course.name}"
    end

    puts "Enabling completed"
  end
end
