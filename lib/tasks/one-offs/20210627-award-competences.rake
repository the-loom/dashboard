=begin

 Cómo correr esto:
 1. con la base recuperada, y updateada
 2. correr esta tarea
$ docker-compose run app rake dev:award_by_rubrics
 3. correr los stats
$ docker-compose run app rake stats:calculate
 4. restaurar la base en prod, o hacerlo directo en prod una vez que probamos que anda en dev

=end

namespace :dev do
  task award_by_rubrics: :environment do
    ActiveRecord::Base.transaction do
      Course.current = Course.find(28)
      # [307, 340, 341, 343]
      challenges = PeerReview::Challenge.where(id: ENV["id"].to_i)
      challenges.each do |ch|
        puts "Premiando #{ch.title}"

        solve = "Resolver '#{ch.title}'"
        solve_event = Event.create(name: solve, description: solve, points: 8, min_points: 8, max_points: 8, competence_tag_id: 15)

        review = "Revisar '#{ch.title}'"
        review_event = Event.create(name: review, description: review, points: 6, min_points: 6, max_points: 12, competence_tag_id: 12)

        extra_review = "Revisión extra sobre '#{ch.title}'"
        extra_review_event = Event.create(name: extra_review, description: extra_review, points: 4, min_points: 0, max_points: 0, competence_tag_id: 12)

        ch.solutions.final.each do |s|
          next unless s.author
          s.author.register(solve_event)
        end

        reviews_by_reviewer = ch.reviews.group_by { |r| r.reviewer }
        reviews_by_reviewer.each do |reviewer, reviews|
          next unless reviewer
          total_reviews = reviews.size
          base_reviews = [total_reviews, ch.expected_reviews].min
          extra_reviews = [total_reviews - base_reviews, 3].min

          reviewer.register(review_event, base_reviews)

          reviewer.register(extra_review_event, extra_reviews)
        end

        cases = "Casos de prueba correctos para '#{ch.title}'"
        cases_event = Event.create(name: cases, description: cases, points: 1, min_points: 3, max_points: 5, competence_tag_id: 14)

        grade = "Puntaje sobre solución de '#{ch.title}'"
        grade_event = Event.create(name: grade, description: grade, points: 1, min_points: 4, max_points: 10, competence_tag_id: 16)

        good_review = "Puntaje como revisor de '#{ch.title}'"
        good_review_event = Event.create(name: good_review, description: good_review, points: 1, min_points: 6, max_points: 10, competence_tag_id: 13)

        ch.solutions.final.each do |sol|
          puts "Premiando #{sol.author.full_name}"
          r = [0, 0, 0, 0, 0]
          sol.reviews.each do |rev|
            ptos_revisor = 0
            5.times do |i|
              v = rev.rubrics["Caso 0#{i + 1}"]
              r[i] += v == 5 ? 1 : (v == 1 ? -1 : 0)
              ptos_revisor += v == 1 || v == 5 ? 1 : 0
            end
            puts "Revisor: #{rev.reviewer.full_name}, #{ptos_revisor}"
            rev.reviewer.register(good_review_event, ptos_revisor)
          end
          posta = r.select { |x| x != 0 }
          ptos_author = posta.map { |x| x > 0 ? 10 : 0 }.sum / [posta.length, 1].max
          if posta.length == 0
            puts "DANGER <<<<<<<<<<<<<<<<<<<<<<<<<< este es indeterminado!"
          end
          sol.author.register(grade_event, ptos_author)

          casos_correctos = posta.map { |x| x > 0 ? 1 : 0 }.sum
          sol.author.register(cases_event, casos_correctos)
        end
      end
    end
  end
end
