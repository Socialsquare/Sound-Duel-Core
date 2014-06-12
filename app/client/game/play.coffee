# app/client/game/play.coffee

# IE fix
`
Element.prototype.remove = function() {
    this.parentElement.removeChild(this);
}
NodeList.prototype.remove = HTMLCollection.prototype.remove = function() {
    for(var i = 0, len = this.length; i < len; i++) {
        if(this[i] && this[i].parentElement) {
            this[i].parentElement.removeChild(this[i]);
        }
    }
}
`

# methods

# http://coffeescriptcookbook.com/chapters/arrays/shuffling-array-elements
shuffle = (a) ->
  # From the end of the list to the beginning, pick element `i`.
  for i in [a.length-1..1]
    # Choose random element `j` to the front of `i` to swap with.
    j = Math.floor Math.random() * (i + 1)
    # Swap `j` with `i`, using destructured assignment
    [a[i], a[j]] = [a[j], a[i]]
  # Return the shuffled array.
  a


# From: http://stackoverflow.com/a/9255507/118608
startCountdown = ->
  # Reset progress bar
  Session.set 'gameProgress', 100
  $('#asset-bar')
    .attr('style', "width: 100%")
    .text Math.floor(currentQuiz().pointsPerQuestion)

  # Hide questions
  $('#alternative-container').hide()

  # Remove countdown
  $countdown = $(".sound-duel-countdown")
  $insertion_point = $countdown.prev()
  # $countdown.remove()
  document.getElementsByClassName("sound-duel-countdown").remove() # fix IE
  $countdown.removeClass('smaller')

  # **iOS**: Ensure that sound is started
  is_iOS = navigator.userAgent.match /(iPad|iPhone|iPod)/g
  is_iOS = true #TODO: ?

  if is_iOS and Session.get('currentQuestion') == 0

    $button = $("<button id='start'
      class='btn btn-primary btn-lg btn-block'>
      Start</button>")

    $button.click ->

      # Play silent audio clip top obtain the right from iOS to play audio
      Template.assets.playSilence()

      # Remove button
      # @remove()
      document.getElementById('start').remove() # fix IE

      startAnimation($insertion_point, $countdown)

    # Insert button
    $insertion_point.after($button)
  else
    Template.assets.loadSound()

    startAnimation($insertion_point, $countdown)

  # Skip animation if spacebar is pressed
  # $('body').keyup (e) ->
  #   if e.keyCode == 32
  #     # user has pressed space
  #     Template.question.showQuestion()

startAnimation = ($insertion_point, $countdown) ->
  # Insert and show countdown
  $insertion_point.after($countdown)
  $countdown.show()

  # Setup variables
  i = 0
  texts = ['3', '2', '1', 'Start']

  $('.sound-duel-countdown').html texts[i]

  return if Session.get('currentQuestion') > 0

  # Change text on every animation iteration
  $(".sound-duel-countdown").bind(
    "animationiteration webkitAnimationIteration oAnimationIteration
     MSAnimationIteration",
    ->
      i += 1
      $(this).text(texts[i])

      if texts[i].length > 2
        $(this).addClass('smaller')
      else
        $(this).removeClass('smaller')
  )

  # When the animation has ended show the questions and play the sound
  $(".sound-duel-countdown").bind(
    "animationend webkitAnimationEnd oAnimationEnd MSAnimationEnd", ->
      Template.question.showQuestion()
      i = 0
  )

answerQuestion = (idx) ->
  # pause asset
  audioPlayer().pause()
  $audioPlayer().unbind('timeupdate')

  # If we answered the last question
  if idx >= currentQuiz().questionIds.length
    Meteor.call 'endGame', currentGameId(), (error, result) ->
      Router.go 'game', _id: currentGameId(), action: 'result'
  else
    # otherwise go to the next question
    Session.set 'currentQuestion', idx
    startCountdown()


# helpers

$audioPlayer = -> $('[data-sd-audio-player]')
audioPlayer = -> $audioPlayer()[0]

Template.assets.helpers

  loadSound: ->
    audioPlayer().src = currentAudioSrc()
    audioPlayer().load()

  # Play <audio> element with 0.3 seconds of silence,
  # in order to workaround iOS limitations on HTML5 audio playback
  playSilence: ->
    audioPlayer().src = '/audio/silence.mp3'
    audioPlayer().play()

    # Load the real question sound after having played the silent audio clip
    audioPlayer().addEventListener('ended', @loadSound, false)

  # start playback of audio element
  playAsset: (callback) ->
    # bind audio progress
    @bindAssetProgress()
    # play
    audioPlayer().play()

  # binds audio element progression with progress bar
  bindAssetProgress: ->
    $audioPlayer().bind 'timeupdate', ->
      percent = (this.currentTime * 100) / this.duration
      Session.set 'gameProgress', percent
      value = (currentQuiz().pointsPerQuestion * (100 - percent)) / 100

      if percent == 0
        text = ""
      else
        text = Math.floor(value) + " point"

      # update progress bar width depending on audio progress
      $('#asset-bar')
        .attr('style', "width: #{100 - percent}%")
        .text text

Template.question.showQuestion = ->
  Meteor.call 'startQuestion', currentGameId(), (err) ->
    if err?
      console.log err
    else
      # Hide countdown, show questions
      $('[data-sd-quiz-progressbar]').show()
      $(".sound-duel-countdown").hide()
      $('#alternative-container').show()

      # Enable answer buttons
      $('.alternative').prop 'disabled', false

      # Play sound
      Template.assets.playAsset()

Template.question.helpers
  currentQuestion: -> currentQuiz().name

  currentQuestionNumber: -> currentGame().currentQuestion + 1

  numberOfQuestions: -> numberOfQuestions()

  alternatives: -> shuffle currentQuestion().alternatives

  progressBarColor: ->
    percent = Session.get 'gameProgress'
    if percent is 100
      ''
    else if percent > 66
      'progress-bar-danger'
    else if percent > 33
      'progress-bar-warning'
    else
      'progress-bar-success'

# Template.question.startQuestion = ->
#   # Reset progress bar
#   $('#asset-bar')
#     .attr('style', "width: 100%")
#     .text Math.floor(currentQuiz().pointsPerQuestion)

#   $('.alternative').prop 'disabled', false

#   Template.assets.playAsset()

# # **iOS**: Ensure that sound is started
# Template.question.ensurePlaying = ->
#   Template.question.startQuestion()


# rendered

Template.question.rendered = ->
  startCountdown()


# events

Template.question.events
  # answer question with clicked alternative
  'click .alternative': (event) ->
    $('.alternative').prop 'disabled', true
    Meteor.call 'stopQuestion',
      currentGameId(), event.target.id, (err, result) ->
        if err?
          console.log err
        else
          answerQuestion result
