Course.current = Course.find(5)

data = [
    { points: 7, uuids: "119, 12E, 203, 206" },
    { points: 3, uuids: "1fa, 20a, 216" },
    { points: 8, uuids: "211, 205, 1F9, 144" },
    { points: 1, uuids: "215, 209, 202" },
    { points: 2, uuids: "151, 139, 22D" },
    { points: 4, uuids: "21B, 227, 1FF, 21A, 219" },
    { points: 6, uuids: "22E, 21F, 224, 1F5" }
]

event = Event.find(25)

data.each do |datum|
  User.where(uuid: datum[:uuids].gsub(/\s+/, "").upcase.split(",")).each do |st|
    datum[:points].times do
      st.register(event)
    end
  end
end
