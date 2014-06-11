# app/client/lobby/lobby.coffee

# methods

startGame = ->
  Meteor.call 'newGame', (error, result) ->
    unless error?
      Session.set 'currentQuestion', 0
      Router.go 'game', _id: result, action: 'play'
    else
      if error.error == 404
        Router.go 'lobby'
        FlashMessages.sendError "Der er ingen quiz i dag"
      else
        console.log error


# helpers

Template.lobby.helpers
  quizOfTheDay: ->
    now = (new Date()).getTime()
    quiz = Quizzes.find({},
      sort: [[ 'startDate', 'desc' ]]
    ).fetch().pop()

    unless quiz?
      "Der er ingen quiz i dag"
    else
      quiz.description


# events

Template.lobby.events
  'click .js-start-game': (event) ->
    startGame({})
