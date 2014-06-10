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
  game_name: -> "Marco's Crazy VM spil"


# events

Template.welcome.events
  'click .js-start-game': (event) ->
    startGame({})
