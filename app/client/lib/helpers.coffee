# app/client/helpers.coffee

# methods

# helper method for failing gracefully when required value is null
failIfNull = (value=null, msg) ->
  # if given value is null, route to home screen and throw error
  unless value?
    Router.go 'lobby'
    throw new Meteor.Error 404, msg
  # else, return the value
  else
    value


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
  failIfNull Questions.findOne(currentQuestionId()),
    "Current question not found (id: #{currentQuestionId()})"

@numberOfQuestions = ->
  Quizzes.findOne(currentGame().quizId).questionIds.length

@currentAudioSrc = ->
  randomSegment = (sound) ->
    return null unless sound.segments?.length
    sound.segments[Math.floor(Math.random() * sound.segments.length)]

  sound = Sounds.findOne currentQuestion().soundId

  "/audio/#{randomSegment(sound)}"
