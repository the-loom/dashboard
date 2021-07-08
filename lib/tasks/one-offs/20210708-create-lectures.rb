ActiveRecord::Base.transaction do
  m = Date.new(2021, 7, 12)
  t = Date.new(2021, 7, 13)
  w = Date.new(2021, 7, 14)
  th = Date.new(2021, 7, 15)
  f = Date.new(2021, 7, 16)

  times_per_course = [
    [35, t, 18, 20, f, 18, 20],
    [36, t, 20, 22, f, 20, 22],
    [37, t, 9, 11, f, 9, 11],
    [38, t, 14, 16, th, 14, 16],
    [39, t, 17, 19, th, 17, 19],
    [40, t, 19, 21, th, 19, 21],
    [41, t, 10, 12, th, 10, 12],
    [42, m, 9, 11, w, 9, 11],
    [43, t, 14, 16, f, 14, 16],
    [44, t, 19, 21, th, 19, 21],
    [45, m, 17, 19, f, 18, 20],
    [46, t, 9, 11, f, 9, 11]
  ]

  time = Time.zone.now

  times_per_course.each do |data|
    Course.current = Course.find(data[0])

    24.times do |i|
      Lecture.create(
        date: m + (i * 7).days,
        summary: "Clase teórica #{i * 2 + 1}",
        time_from: time.change({ hour: 19 }),
        time_to: time.change({ hour: 21 })
      )

      Lecture.create(
        date: w + (i * 7).days,
        summary: "Clase teórica #{i * 2 + 2}",
        time_from: time.change({ hour: 19 }),
        time_to: time.change({ hour: 21 })
      )

      Lecture.create(
        date: data[1] + (i * 7).days,
        summary: "Tutoría #{i * 2 + 1}",
        time_from: time.change({ hour: data[2] }),
        time_to: time.change({ hour: data[3] })
      )

      Lecture.create(
        date: data[4] + (i * 7).days,
        summary: "Tutoría #{i * 2 + 2}",
        time_from: time.change({ hour: data[5] }),
        time_to: time.change({ hour: data[6] })
      )
    end
  end
end
