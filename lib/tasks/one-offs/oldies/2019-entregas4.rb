Course.current = Course.find(2)

Lecture lecture = Lecture.find(47)

data = [
    { team_id: 3, times: 7 },
    { team_id: 1, times: 9 },
    { team_id: 2, times: 4 },
    { team_id: 10, times: 2 },
    { team_id: 9, times: 10 },
    { team_id: 8, times: 2 },
    { team_id: 4, times: 10 },

    { team_id: 6, times: 4 },

    { team_id: 5, times: 9 }

]

event = Event.find(17)

data.each do |datum|
  team = Team.find(datum[:team_id])
  team.members.each do |member|
    datum[:times].times do
      member.register(event) if member.present_at(lecture)
    end
  end
end
