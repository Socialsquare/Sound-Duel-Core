# app/client/game/result.coffee

# helpers

Template.result.helpers
  result: ->
    game = currentGame()
    {
      score: game.score
      ratio: "#{game.correctAnswers}/#{numberOfQuestions()}"
    }

Template.socialshare.helpers
  url: -> Meteor.absoluteUrl(Router.current().path)


# events

Template.result.events
  'click a#restart': ->
    Session.set 'currentGameId', ''
    Router.go 'lobby'

Template.socialshare.events
  'click .js-share-facebook': (event) ->
    event.preventDefault()
    FB.ui({
      # method: 'share_open_graph',
      # action_type: 'og.likes',
      # action_properties: JSON.stringify({
      #   object:window.location.href,
      # })
      method: 'share',
      href: Meteor.absoluteUrl(Router.current().path),
    }, (response) ->
      console.log(response)
    )
  'click .js-share-google,.js-share-twitter': (event) ->
    event.preventDefault()
    width = 400
    height = 300
    $window = $(window)
    leftPosition = ($window.width() / 2) - ((width / 2) + 10)
    topPosition = ($window.height() / 2) - ((height / 2) + 50)
    windowFeatures = "status=no,height=" +height +
    ",width=" + width +
    ",resizable=yes,left=" + leftPosition +
    ",top=" + topPosition +
    ",toolbar=no,menubar=no,scrollbars=no,location=no,directories=no"
    window.open($(event.target).attr('href'),'sharer', windowFeatures)
