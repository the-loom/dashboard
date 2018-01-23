require "ffaker"

# every existing user in the database will be promoted to teacher
User.all.update_all(role: :teacher)

# TODO(delucas): organizar esto en grupos
50.times do
  name = "#{FFaker::NameMX.first_name} #{FFaker::NameMX.last_name}"
  nickname = ActiveSupport::Inflector.transliterate(name.downcase.gsub(/\s/, "."))

  user = User.create(
    name: name,
    nickname: nickname,
    email: "#{nickname}@yopmail.com",
    image: FFaker::Avatar.image,
    role: :student,
    enabled: true,
    locked: true
  )
  Identity.create(
    user: user,
    provider: "github",
    uid: rand(10**8),
    name: user.name,
    nickname: user.nickname,
    email: user.email,
    image: user.image
  )
end
