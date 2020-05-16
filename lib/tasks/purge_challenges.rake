namespace :challenges do
  desc "Purges due PeerReview::Challenges"
  task purge: :environment do
    Course.enabled.each do |course|
      Course.current = course
      next unless course.on?(:peer_review_challenges)
      puts "Purging Challenges for Course #{course.name}"

      PeerReview::Challenge.all.each do |challenge|
        if challenge.due? && challenge.needs_purge?
          challenge.purge!
          puts "-> #{challenge.title} has been purged"
        end
      end

      puts "Finished purging for Course #{course.name}"
    end

    puts "Purging completed"
  end
end
