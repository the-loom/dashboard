require "ffaker"

# TODO(delucas): organizar esto en grupos
3.times do 

  c = Course.create(
    name: 'Programación ' + rand(10).roman
  )

  35.times do
    name = "#{FFaker::NameMX.first_name} #{FFaker::NameMX.last_name}"
    nickname = ActiveSupport::Inflector.transliterate(name.downcase.gsub(/\s/, "."))

    user = User.create(
      name: name,
      nickname: nickname,
      email: "#{nickname}@yopmail.com",
      image: FFaker::Avatar.image,
      enabled: true,
      locked: true
    )
    user.memberships << Membership.create(
      course: c,
      role: :student
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
end
