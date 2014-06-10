# app/client/lobby/lobby.coffee

# methods

startGame = ->
  Meteor.call 'newGame', (error, result) ->
    unless error?
      Session.set 'currentQuestion', 0
      Session.set 'currentGameId', result
      Router.go 'game', _id: result, action: 'play'
    else
      console.log error


# helpers

Template.lobby.helpers
  game_name: -> "Marco's Crazy VM spil"


# events

Template.welcome.events
  'click .js-start-game': (event) ->
    startGame({})
