namespace :challenges do
  desc "Disables due PeerReview::Challenges"
  task disable: :environment do
    Course.enabled.each do |course|
      Course.current = course
      next unless course.on?(:peer_review_challenges)
      puts "Disabling Challenges for Course #{course.name}"

      PeerReview::Challenge.all.each do |challenge|
        if challenge.due?
          challenge.disable!
          puts "-> #{challenge.title} has been disabled"
        end
      end

      puts "Finished disabling for Course #{course.name}"
    end

    puts "Disabling completed"
  end
end
