class User < ApplicationRecord

  enum role: {
      guest: 0,
      student: 1,
      teacher: 2
  }

  has_many :occurrences
  has_many :events, through: :occurrences

  def register(event)
    events_count = events.count { |x| x.name == event.name } + 1
    if events_count % event.batch_size == 0
      points_per_event = event.points_per_batch
    else
      points_per_event = 0
    end
    occurrences.create(event: event, points: 0)
    self.points = self.points + points_per_event
  end

  def self.sorted
    self.order(:name)
  end

  def self.by_omniauth(auth)
    user = self.find_by(provider: auth["provider"], uid: auth["uid"]) || self.create_with_omniauth(auth)
    user.update_attribute(:image, auth['info']['image'])
    user
  end

  private
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['name']
      user.nickname = auth['info']['nickname']
      user.email = auth['info']['email']
      user.image = auth['info']['image']
    end
  end
end
