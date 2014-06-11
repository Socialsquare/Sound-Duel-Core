# app/client/game/result.coffee

# helpers

Template.result.helpers
  result: ->
    game = currentGame()
    {
      score: game.score
      ratio: "#{game.correctAnswers}/#{numberOfQuestions()}"
    }

  isHighscore: ->
    return false if currentGame().score == 0

    highscores = Highscores.find
      quizId: currentQuizId()
      score: { $gt: 0 }
    ,
      sort: [[ 'score', 'desc' ]]
      limit: 20

    if highscores.count() < 20
      true
    else
      worst = highscores.fetch().pop()
      currentGame().score > worst.score

Template.socialshare.helpers
  url: -> 'http://www.dr.dk/sporten/fifavm2014/quiz'


# events

Template.result.events
  'click a#restart': -> Router.go 'lobby'

Template.submit.events
  'click button#submit-highscore': (evt) ->
    evt.preventDefault()
    $('button#submit-highscore').attr 'disabled', true

    name = "#{$('input#submit-name').val()}".replace /^\s+|\s+$/g, ""
    unless name
      FlashMessages.sendError "Dit navn kan ikke være tomt"
      $('button#submit-highscore').attr 'disabled', false
      return

    Meteor.call 'submitHighscore', name, currentGameId(), (error, result) ->
      if error?
        console.log error
        $('button#submit-highscore').attr 'disabled', false
      else
        Router.go 'highscores'

Template.socialshare.events
  'click .share': (event) ->
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
