ActiveRecord::Base.transaction do
  Course.current = Course.find(2)

  challenges = PeerReview::Challenge.where(id: [1, 2])
  challenges.each do |challenge|
    # 1. crear los premios
    participation = Event.create(
      name: "Participacion en Desafio '#{challenge.title}'",
      description: "Resolvio el desafio",
      points: 5,
      min_points: 5,
      max_points: 5
    )

    revision = Event.create(
      name: "Revision del Desafio '#{challenge.title}'",
      description: "Reviso soluciones del desafio",
      points: 2,
      min_points: 2,
      max_points: 2
    )

    # 2. asignar premio a la resolución
    challenge.solutions.map(&:author).each do |user|
      user.register(participation)
    end

    # 3. asignar premio a la revisión
    challenge.reviews.map(&:reviewer).each do |user|
      user.register(revision)
    end
  end
end
