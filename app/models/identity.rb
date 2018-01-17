class Identity < ApplicationRecord

  belongs_to :user

  # https://github.com/omniauth/omniauth/wiki/Managing-Multiple-Providers
  # https://www.sitepoint.com/rails-authentication-oauth-2-0-omniauth/
  # https://console.developers.google.com/apis/credentials?project=loom-development
  def self.by_omniauth(auth)
    identity = self.find_by(provider: auth["provider"], uid: auth["uid"]) || self.create_with_omniauth(auth)
    identity.update_attribute(:image, auth['info']['image'])
    identity
  end

  private
  def self.create_with_omniauth(auth)
    create! do |identity|
      identity.provider = auth['provider']
      identity.uid = auth['uid']
      identity.name = auth['info']['name']
      identity.nickname = auth['info']['nickname'].present? ? auth['info']['nickname'] : auth['info']['email'].split('@').first
      identity.email = auth['info']['email']
      identity.image = auth['info']['image']
      identity.user = self.resolve(auth['info'])
    end
  end

  def self.resolve(info)
    i = Identity.find_by(email: info['email'])
    if i.present?
      i.user
    else
      User.create! do |user|
        user.name = info['name']
        user.nickname = info['nickname']
        user.email = info['email']
        user.image = info['image']
      end
    end
  end

end
