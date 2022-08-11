ActiveRecord::Base.transaction do
  m = Date.new(2022, 8, 15)
  t = Date.new(2022, 8, 16)
  w = Date.new(2022, 8, 17)
  th = Date.new(2022, 8, 18)
  f = Date.new(2022, 8, 19)

  times_per_course = [
    [68, w, 8, 12, th, 8, 12],
    [69, t, 18, 22, th, 18, 22],
    [70, w, 18, 22, f, 18, 22]
  ]

  time = Time.zone.now

  times_per_course.each do |data|
    Course.current = Course.find(data[0])

    15.times do |i|
      Lecture.create(
        date: data[1] + (i * 7).days,
        summary: "Clase #{i * 2 + 3}",
        time_from: time.change({ hour: data[2] }),
        time_to: time.change({ hour: data[3] })
      )

      Lecture.create(
        date: data[4] + (i * 7).days,
        summary: "Clase #{i * 2 + 4}",
        time_from: time.change({ hour: data[5] }),
        time_to: time.change({ hour: data[6] })
      )
    end
  end
end
