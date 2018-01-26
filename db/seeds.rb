require "ffaker"
require "roman"

# TODO(delucas): organizar esto en grupos
3.times do

  course = Course.create(
    name: "Programación #{rand(10).roman}"
  )
  Course.current = course

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

pptlS = AutomaticCorrection::Repo.create(
  user: "the-loom",
  name: "piedra-papel-tijera-lagarto-Spock",
  git_url: "git@github.com:the-loom/piedra-papel-tijera-lagarto-Spock.git",
  avatar_url: "https://avatars.githubusercontent.com/u/5033965?v=3",
  description: "Repo description pending"
)

author = User.last
fork = AutomaticCorrection::Repo.create(
  author: author,
  user: author.nickname,
  name: "piedra-papel-tijera-lagarto-Spock",
  git_url: "git@github.com:#{author.nickname}/piedra-papel-tijera-lagarto-Spock.git",
  avatar_url: author.image,
  description: "Repo description pending"
)

pptlS.forks << fork

first_test_run = AutomaticCorrection::TestRun.create(
  score: 4.83,
  git_commit_id: "25def259c9cbe610b1f85867d76b05539585ebe4"
)

fork.test_runs << first_test_run

junit_result = AutomaticCorrection::Result.create(
  score: 3.33,
  test_type: "junit"
                                                  )
first_test_run.results << junit_result

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

checkstyle_result = AutomaticCorrection::Result.create(
  score: 1.5,
  test_type: "checkstyle"
)
first_test_run.results << checkstyle_result

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
