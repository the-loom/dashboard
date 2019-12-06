Course.current = Course.find(2)

data = [
    { uuids: "116, 121, 119, 12A, 128", points: 7 },
    { uuids: "168, 11C, 12B", points: 4 },
    { uuids: "118, 123, 126, 11F", points: 1 },
    { uuids: "158, 127, 11D, 129", points: 1 },
    { uuids: "118, 11F, 123, 126", points: 4 },
    { uuids: "124, 11A, 122, 125", points: 1 },
    { uuids: "13A, 14D, 138, 152", points: 1 },
    { uuids: "145, 156, 139", points: 6 },
    { uuids: "154, 158, 15A", points: 2 },
    { uuids: "131, 14F, 140", points: 0 },
    { uuids: "13B, 15B, 14E", points: 5 },
    { uuids: "14A, 13E, 150", points: 3 },
    { uuids: "133, 149, 14D, 141", points: 0 },
    { uuids: "136, 155, 148", points: 1 },
    { uuids: "135, 143, 151", points: 5 },
    { uuids: "134, 169, 142", points: 2 },
    { uuids: "13D, 14B, 137", points: 0 },
    { uuids: "13C, 153, 132", points: 0 }
]

event = Event.find(6)

data.each do |datum|
  User.where(uuid: datum[:uuids].gsub(/\s+/, "").upcase.split(",")).each do |st|
    datum[:points].times do
      st.register(event)
    end
  end
end
