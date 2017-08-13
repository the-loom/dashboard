# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.create(
        provider: 'github',
        uid: 684051,
        name: 'Lucas Videla',
        nickname: 'delucas',
        email: 'videla.lucas@gmail.com',
        image: 'https://avatars2.githubusercontent.com/u/684051?v=3',
        role: :teacher,
        enabled: true,
        locked: true
)
