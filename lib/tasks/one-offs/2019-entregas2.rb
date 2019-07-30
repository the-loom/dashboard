Course.current = Course.find(2)

Lecture lecture = Lecture.find(5)

data = [
    { team_id: 1, times: 9 },
    { team_id: 2, times: 8 },
    { team_id: 3, times: 7 },
    { team_id: 4, times: 7 },
    { team_id: 5, times: 7 },
    { team_id: 6, times: 7 },
    { team_id: 7, times: 4 },
    { team_id: 8, times: 6 },
    { team_id: 9, times: 8 },
    { team_id: 10, times: 8 }
]

event = Event.find(7)

data.each do |datum|
  team = Team.find(datum[:team_id])
  team.members.each do |member|
    datum[:times].times do
      member.register(event) if member.present_at(lecture)
    end
  end
end
