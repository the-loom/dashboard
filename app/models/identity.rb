class Identity < ApplicationRecord
  belongs_to :user

  # https://github.com/omniauth/omniauth/wiki/Managing-Multiple-Providers
  # https://www.sitepoint.com/rails-authentication-oauth-2-0-omniauth/
  # https://console.developers.google.com/apis/credentials?project=loom-development
  def self.by_omniauth(auth)
    identity = find_by(provider: auth["provider"], uid: auth["uid"]) || create_with_omniauth(auth)
    identity.user = find_corresponding_user(identity) if identity.user == nil
    identity.update_attribute(:image, auth["info"]["image"])
    identity.update_attribute(:first_name, auth["info"]["name"])
    identity
  end

  def full_name
    "#{last_name}, #{first_name}"
  end

  private
    def self.create_with_omniauth(auth)
      create! do |identity|
        name_parts = (auth["info"]["name"] || "Nomen Nescio").rpartition(" ")
        identity.provider = auth["provider"]
        identity.uid = auth["uid"]
        identity.first_name = name_parts.first
        identity.last_name = name_parts.last
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
      if identity.email.present?
        u = User.find_or_create_by(email: identity.email)
      else
        u = User.new
      end
      u.uuid = rand * 1000 # temp hotfix!
      u.update_with(identity)
      u.update_attribute(:uuid, (u.id + 272).to_s(16).upcase)
      u
    end
end
