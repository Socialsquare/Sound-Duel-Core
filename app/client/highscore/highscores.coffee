# app/client/highscore/highscores.coffee

MONTHS = [
  'Januar'
  'Februar'
  'Marts'
  'April'
  'Maj'
  'Juni'
  'Juli'
  'August'
  'September'
  'Oktober'
  'November'
  'December'
]

# helpers

Template.highscores.helpers
  quizzes: ->
    today = new Date()
    quizzes = Quizzes.find startDate: { $lt: today} ,
      sort: [[ 'startDate', 'asc' ]]

  highscores: ->
    selectedId = $("#quiz-selector option:selected").data('quiz-id')
    quizId = Session.get 'quizId' or selectedId

    Highscores.find
      quizId: quizId
      score: { $gt: 0 }
    ,
      sort: [[ 'score', 'desc' ]]
      limit: 20

UI.registerHelper 'selected', (quizId) ->
  now = (new Date()).getTime()
  quiz = Quizzes.findOne quizId

  if quiz.startDate.getTime() < now and now < quiz.endDate.getTime()
    Session.set 'quizId', quizId
    'selected'

UI.registerHelper 'displayDate', (date) ->
  "#{date.getDate()}. #{MONTHS[date.getMonth()]}"

UI.registerHelper 'withPosition', (cursor) ->
  cursor.map (element, i) ->
    element.position = i + 1
    element


# events

Template.highscores.events
  'change select#quiz-selector': ->
    quizId = $('#quiz-selector option:selected').data('quiz-id')
    Session.set 'quizId', quizId
