ada = User.where(uuid: %w(133 120 15B))
bot = User.where(uuid: %w(12B 156 15C))
elmejorbot = User.where(uuid: %w(134 127 12E 12C 146))
jugadorbot = User.where(uuid: %w(14E 14B))
demorganuno = User.where(uuid: %w(121 150 124 14F))
messi = User.where(uuid: %w(13E 15F 125 147))
jabba = User.where(uuid: %w(145 116 14D 11D))
cosmefulanito = User.where(uuid: %w(13B 13F 123 13C))

bot2 = User.where(uuid: %w(160 135 122 165))
gdr = User.where(uuid: %w(143 141))
botistuta = User.where(uuid: %w(12F 153 136 159))
fonzo = User.where(uuid: %w(131 14C 137 11E))
phc = User.where(uuid: %w(11B 115 11A))
mcl = User.where(uuid: %w(117 12D 128 129))
megajugador = User.where(uuid: %w(14A 13A 149 11C))
neo = User.where(uuid: %w(15A 139 140 15D))
participante = User.where(uuid: %w(155 154 161 142))
zidane = User.where(uuid: %w(130 12A 151))

# Participacion
participation = Event.find(2)
participants = Lecture.find(10).attendances.where(condition: 1).map(&:user)
participants.each do |participant|
  participant.register(participation)
end

# Ganadores TM
first = Event.find(3)
cosmefulanito.each do |user|
  user.register(first)
end
second = Event.find(4)
demorganuno.each do |user|
  user.register(second)
end
third = Event.find(5)
elmejorbot.each do |user|
  user.register(third)
end

# Ganadores TT
first = Event.find(3)
zidane.each do |user|
  user.register(first)
end
second = Event.find(4)
neo.each do |user|
  user.register(second)
end
third = Event.find(5)
botistuta.each do |user|
  user.register(third)
end

# Ganador Torneo Mayor
tournament_badge = Badge.find(4)
zidane.each do |user|
  user.earn(tournament_badge)
end

# Ganador Liga
# league_badge = Badge.find(5)
# xxx.each do |user|
#   user.earn(league_badge)
# end

# Ganadores desafios bots
wally = Event.find(6)
[ada, bot, jugadorbot, messi, cosmefulanito, bot2,
 gdr, botistuta, fonzo, phc, mcl, megajugador,
 participante, zidane].flatten.each do |user|
  user.register(wally)
end

brandom = Event.find(7)
simple_bot = Badge.find(6)
[ada, messi, jabba, botistuta, mcl, megajugador,
 neo, zidane].flatten.each do |user|
  user.register(brandom)
  user.earn(simple_bot)
end

wheatley = Event.find(8)
simple_bot = Badge.find(6)
[elmejorbot, demorganuno, botistuta, phc, megajugador,
 neo, zidane].flatten.each do |user|
  user.register(wheatley)
  user.earn(simple_bot)
end

glados = Event.find(9)
super_bot = Badge.find(7)
[elmejorbot, cosmefulanito, fonzo,
 megajugador, neo].flatten.each do |user|
  user.register(glados)
  user.earn(super_bot)
end
