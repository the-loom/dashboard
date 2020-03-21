require "ffaker"
require "roman"

# TODO(delucas): organizar esto en grupos
3.times do |course_number|
  course = Course.create(
    name: "Programación #{(course_number + 1).roman}",
    password: "123456"
    # TODO: enable some features?
  )

  Course.current = course

  7.times do |team_number|
    current_team = Team.create(
      name: "Equipo #{(team_number + 1).roman}",
      nickname: "equipo_#{team_number + 1}"
      # TODO: add avatar!
    )

    5.times do |student_number|
      first_name = FFaker::NameMX.first_name
      last_name = FFaker::NameMX.last_name
      name = "#{first_name} #{last_name}"
      nickname = ActiveSupport::Inflector.transliterate(name.downcase.gsub(/\s/, "."))

      user = User.create(
        first_name: first_name,
        last_name: last_name,
        nickname: nickname,
        email: "#{nickname}@yopmail.com",
        uuid: ((course_number + 1) * 100 + (student_number + 1)).to_s(16).upcase
        # TODO: add avatar!
      )
      membership = Membership.create(
        course: course,
        role: :student,
        user: user,
        enabled: true
      )
      current_team.memberships << membership

      Identity.create(
        user: user,
        provider: "github",
        uid: rand(10 ** 8),
        first_name: user.first_name,
        last_name: user.last_name,
        nickname: user.nickname,
        email: user.email,
        image: user.image
        # TODO: image? user.image? should we use avatar and that's it?
      )
    end
  end
end

Course.current = Course.first

challenge = PeerReview::Challenge.create(
  title: "Comprobar el orden de un arreglo",
  difficulty: 1,
  instructions: "<div>Implementá un método que decida si un arreglo dado está o no ordenado:</div>
<pre>
public boolean ordenado(int[] arreglo) {
  // tu código aquí
}
</pre>",
  reviewer_instructions: "<div>Deberás estar atento a:</div>
<ul>
<li>Que no se utilicen variables innecesarias</li>
<li>Que se recorra el arreglo una única vez</li>
<li>Que no haya más de un punto de retorno</li>
</ul>
<div>Recordá dar un feedback completo y abarcativo, incluyendo tu propia opinión</div>"
)

first_solver = Course.current.users.first
second_solver = Course.current.users.second

solution1 = PeerReview::Solution.create(
  author: first_solver,
  wording: "
<pre>
public boolean ordenado(int[] arreglo) {
  return true;
}
</pre>
",
  status: :final,
  challenge: challenge
)

solution2 = PeerReview::Solution.create(
  author: second_solver,
  wording: "
<pre>
public boolean ordenado(int[] arreglo) {
  return false;
}
</pre>
",
  status: :final,
  challenge: challenge
)

PeerReview::Review.create(
  reviewer: second_solver,
  solution: solution1,
  wording: "
<div>Creo que no está bien retornar una constante... ¡este método no resiste la menor prueba!</div>
<ul>
<li>No utiliza variables innecesarias, porque no utiliza ninguna...</li>
<li>No resuelve el problema</li>
</ul>
",
  status: :final
)

PeerReview::Review.create(
  reviewer: first_solver,
  solution: solution2,
  wording: "<div>Jeje es mi misma solución, pero yo retorno <pre>true</pre> :P</div>",
  status: :final
)

AutomaticCorrection::Repo.create(
  user: "the-loom",
  name: "hola-mundo",
  git_url: "git@github.com:the-loom/hola-mundo.git",
  avatar_url: "https://avatars.githubusercontent.com/u/5033965?v=3",
  description: "Proyecto para verificar la configuración inicial y la mecánica de la plataforma",
  difficulty: 1
)

pptlS = AutomaticCorrection::Repo.create(
  user: "the-loom",
  name: "piedra-papel-tijera-lagarto-Spock",
  git_url: "git@github.com:tallerweb/piedra-papel-tijera-lagarto-Spock.git",
  avatar_url: "https://avatars.githubusercontent.com/u/5033965?v=3",
  description: "Repo description pending",
  difficulty: 2
)

author = User.first
pptlS.forks << AutomaticCorrection::Repo.create(
  author: author,
  user: author.nickname,
  name: "piedra-papel-tijera-lagarto-Spock",
  git_url: "git@github.com:#{author.nickname}/piedra-papel-tijera-lagarto-Spock.git",
  avatar_url: author.image,
  pending: true,
  difficulty: 2,
  description: "Repo description pending"
)

author = User.last
pptlS.forks << AutomaticCorrection::Repo.create(
  author: author,
  user: author.nickname,
  name: "piedra-papel-tijera-lagarto-Spock",
  git_url: "git@github.com:#{author.nickname}/piedra-papel-tijera-lagarto-Spock.git",
  avatar_url: author.image,
  pending: false,
  difficulty: 2,
  description: "Repo description pending",
  test_runs: [
      AutomaticCorrection::TestRun.create(
        score: 4.83,
        git_commit_id: "25def259c9cbe610b1f85867d76b05539585ebe4",
        results: [
            AutomaticCorrection::Result.create(
              score: 3.33,
              test_type: "junit"
            ),
            AutomaticCorrection::Result.create(
              score: 1.5,
              test_type: "checkstyle"
            )
        ]
      ),
      AutomaticCorrection::TestRun.create(
        score: 7.23,
        git_commit_id: "25def259c9cbe610b1f85867d76b05539585ebe4",
        results: [
            AutomaticCorrection::Result.create(
              score: 5.23,
              test_type: "junit"
            ),
            AutomaticCorrection::Result.create(
              score: 2,
              test_type: "checkstyle"
            )
        ]
      ),
      AutomaticCorrection::TestRun.create(
        score: 8.33,
        git_commit_id: "25def259c9cbe610b1f85867d76b05539585ebe4",
        results: [
            AutomaticCorrection::Result.create(
              score: 6.33,
              test_type: "junit"
            ),
            AutomaticCorrection::Result.create(
              score: 2,
              test_type: "checkstyle"
            )
        ]
      )
  ]
)


=begin
junit_result.issues << AutomaticCorrection::Issue.create(
  message: "java.lang.RuntimeException: Pucha che!",
  issue_type: "java.lang.RuntimeException",
  details: 'java.lang.RuntimeException: Pucha che!
        at edu.tallerweb.conjuntos.ConjuntoTests.unoQueDaError(ConjuntoTests.java:20)
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.lang.reflect.Method.invoke(Method.java:606)',
  payload: { test_class: "edu.tallerweb.conjuntos.ConjuntoTests",
            test_name: "unoQueDaError",
            test_time: 0.003
  }
)
junit_result.issues << AutomaticCorrection::Issue.create(
  message: "java.lang.AssertionError: opa, un failure! atento!",
  issue_type: "java.lang.AssertionError",
  details: 'java.lang.AssertionError: opa, un failure! atento!
  at org.junit.Assert.fail(Assert.java:88)
  at org.junit.Assert.assertTrue(Assert.java:41)
  at edu.tallerweb.conjuntos.ConjuntoTests.unoQueDaFailure(ConjuntoTests.java:15)
  at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
  at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)',
  payload: {
      test_class: "edu.tallerweb.conjuntos.ConjuntoTests",
      test_name: "unoQueDaFailure",
      test_time: 0.0
  }
)

checkstyle_result.issues << AutomaticCorrection::Issue.create(
  message: "Missing a Javadoc comment.",
  issue_type: "error",
  details: "Missing a Javadoc comment.",
  payload: {
      line: 3,
      column: 9,
      filename: "/home/lucas/workspace-grails/loom-daemon/wecodeio-loom-base-repo/src/main/java/edu/tallerweb/conjuntos/Conjunto.java"
  }
)
checkstyle_result.issues << AutomaticCorrection::Issue.create(
  message: "Missing a Javadoc comment.",
  issue_type: "error",
  details: "Missing a Javadoc comment.",
  payload: {
      line: 6,
      column: 9,
      filename: "/home/lucas/workspace-grails/loom-daemon/wecodeio-loom-base-repo/src/main/java/edu/tallerweb/conjuntos/Conjunto.java"
  }
)
=end
