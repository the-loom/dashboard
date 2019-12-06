Course.current = Course.find(2)

# awards
data = [
    { uuids: "123, 118", position: 1 },
    { uuids: "127, 129", position: 2 },
    { uuids: "121, 126, 12A", position: 3 },
    { uuids: "134, 13D, 142", position: 1 },
    { uuids: "135, 143", position: 2 },
    { uuids: "140, 141", position: 3 }
]

podium = Event.find(14)

data.each do |datum|
  User.where(uuid: datum[:uuids].gsub(/\s+/, "").upcase.split(",")).each do |st|
    times_per_position(datum[:position]).times do
      st.register(podium)
    end
  end
end

# battle_royale
data = [
    { uuids: "127, 129, 11D", position: 1 },
    { uuids: "123, 118", position: 2 },
    { uuids: "121, 116, 12A", position: 3 },
    { uuids: "136, 13B", position: 1 },
    { uuids: "134, 13D, 142", position: 2 },
    { uuids: "14E, 155, 15B", position: 3 }
]

battle_royale_podium = Event.find(15)

data.each do |datum|
  User.where(uuid: datum[:uuids].gsub(/\s+/, "").upcase.split(",")).each do |st|
    times_per_position(datum[:position]).times do
      st.register(battle_royale_podium)
    end
  end
end
