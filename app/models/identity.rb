class Identity < ApplicationRecord
  belongs_to :user

  # https://github.com/omniauth/omniauth/wiki/Managing-Multiple-Providers
  # https://www.sitepoint.com/rails-authentication-oauth-2-0-omniauth/
  # https://console.developers.google.com/apis/credentials?project=loom-development
  def self.by_omniauth(auth)
    identity = find_by(provider: auth["provider"], uid: auth["uid"]) || create_with_omniauth(auth)
    identity.update_attribute(:image, auth["info"]["image"])
    identity
  end

  private
    def self.create_with_omniauth(auth)
      create! do |identity|
        identity.provider = auth["provider"]
        identity.uid = auth["uid"]
        identity.name = auth["info"]["name"]
        identity.nickname = extract_nickname(auth["info"])
        identity.email = auth["info"]["email"]
        identity.image = auth["info"]["image"]
        identity.user = find_corresponding_user(identity)
      end
    end

    def self.extract_nickname(info)
      info["nickname"].present? ? info["nickname"] : info["email"].split("@").first
    end

    def self.find_corresponding_user(identity)
      u = User.find_or_create_by(email: identity.email)
      u.update_with(identity)
    end
end
