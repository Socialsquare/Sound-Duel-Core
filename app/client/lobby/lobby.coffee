# app/client/lobby/lobby.coffee

# methods

startGame = (quiz) ->
  Meteor.call 'newGame', quiz, (error, result) ->
    unless error?
      Session.set 'currentQuestion', 0
      Router.go 'game', _id: result, action: 'play'
    else
      if error.error == 404
        Router.go 'lobby'
        FlashMessages.sendError "Der er ingen quiz i dag"
      else
        console.log error

getRandomQuiz = ->
  all = Quizzes.find()
  selected = Math.floor(Math.random() * (all.count() + 1))
  all.fetch()[selected]

getQuizForSession = ->
  if not Session.get('selectedQuizId')?
    currentQuiz = getRandomQuiz()
    Session.set 'selectedQuizId', currentQuiz._id

  Quizzes.findOne _id: Session.get ('selectedQuizId')

# helpers

Template.lobby.helpers
  quizOfTheDay: ->
    getQuizForSession().description

# events

Template.lobby.events
  'click .js-start-game': (event) ->
    startGame getQuizForSession()
