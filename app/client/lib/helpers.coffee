# app/client/helpers.coffee

# helpers

UI.registerHelper 'gameName', -> "Marco's Crazy VM spil"

@currentGameId = -> Session.get 'currentGameId'

@currentGame = -> Games.findOne currentGameId()

@currentQuizId = -> currentGame().quizId

@currentQuiz = -> Quizzes.findOne currentQuizId()

@currentQuestionId = ->
  i = Session.get 'currentQuestion'
  currentQuiz().questionIds[i]

@currentQuestion = ->
  question = Questions.findOne currentQuestionId()

  unless question?
    Router.go 'lobby'
    throw new Meteor.Error 404,
      "Question not found (id: '#{currentQuestionId()}')"
  else
    question

@numberOfQuestions = ->
  Quizzes.findOne(currentGame().quizId).questionIds.length

@currentAudioSrc = ->
  randomSegment = (sound) ->
    return null unless sound.segments?.length
    sound.segments[Math.floor(Math.random() * sound.segments.length)]

  sound = Sounds.findOne currentQuestion().soundId

  "/audio/#{randomSegment(sound)}"
