require "ffaker"
require "roman"

delucas = User.create(
  name: "Lucas Videla",
  nickname: "delucas",
  email: "lucas@wecode.io",
  image: "https://avatars1.githubusercontent.com/u/684051?v=4",
  enabled: true,
  locked: true
)

Identity.create(
  user: delucas,
  provider: "github",
  uid: "684051",
  name: "Lucas Videla",
  nickname: "delucas",
  email: "lucas@wecode.io",
  image: "https://avatars1.githubusercontent.com/u/684051?v=4"
)

# TODO(delucas): organizar esto en grupos
3.times do

  course = Course.create(
    name: "Programación #{rand(10).roman}"
  )
  Course.current = course

  Membership.create(
    course: course,
    role: :admin,
    user: delucas
  )

  35.times do
    name = "#{FFaker::NameMX.first_name} #{FFaker::NameMX.last_name}"
    nickname = ActiveSupport::Inflector.transliterate(name.downcase.gsub(/\s/, "."))

    user = User.create(
      name: name,
      nickname: nickname,
      email: "#{nickname}@yopmail.com",
      image: FFaker::Avatar.image,
      enabled: true,
      locked: true
    )
    Membership.create(
      course: course,
      role: :student,
      user: user
    )
    Identity.create(
      user: user,
      provider: "github",
      uid: rand(10**8),
      name: user.name,
      nickname: user.nickname,
      email: user.email,
      image: user.image
    )
  end
end

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
  pending: true
)

author = User.last
pptlS.forks << AutomaticCorrection::Repo.create(
  author: author,
  user: author.nickname,
  name: "piedra-papel-tijera-lagarto-Spock",
  git_url: "git@github.com:#{author.nickname}/piedra-papel-tijera-lagarto-Spock.git",
  avatar_url: author.image,
  pending: false,
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
