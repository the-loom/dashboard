class User < ApplicationRecord

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
