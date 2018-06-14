Course.current = Course.first

data = [
    {uuids: "14F, 121, 124, 150", points: 1},
    {uuids: "147, 123, 15F", points: 2},
    {uuids: "127, 12E, 12C", points: 4},
    {uuids: "13E, 125, 13F", points: 2},
    {uuids: "12B, 13D, 15C, 156", points: 1},
    {uuids: "133, 14D, 15B", points: 4},
    {uuids: "146, 148", points: 4},
    {uuids: "136, 153, 159, 12F", points: 2},
    {uuids: "155, 161, 142, 154", points: 5},
    {uuids: "143, 141, 162, 11C", points: 0},
    {uuids: "11E, 14A, 131, 13A", points: 2},
    {uuids: "157, 140, 139, 15A", points: 0},
    {uuids: "11B, 115, 11A, 160", points: 2},
    {uuids: "15D, 158, 163, 164", points: 3},
    {uuids: "135, 122, 165, 149", points: 2},
    {uuids: "14C, 12A, 130, 137", points: 0}
]

event = Event.find(1)

data.each do |datum|
  User.where(uuid: datum[:uuids].gsub(/\s+/, "").upcase.split(",")).each do |st|
    datum[:points].times do
      st.register(event)
    end
  end
end
