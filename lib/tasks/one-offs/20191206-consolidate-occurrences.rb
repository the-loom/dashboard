ActiveRecord::Base.transaction do
  Course.all.each do |course|
    Course.current = course

    Membership.where(course: course).each do |membership|
      next unless membership.user
      membership.user.occurrences.group_by(&:event).each do |event, occurrences|
        occurrences.first.multiplier = occurrences.size
        occurrences.first.save

        deletable_ids = occurrences.map(&:id) - [occurrences.first.id]
        Occurrence.delete(deletable_ids)
      end
    end
  end
end
