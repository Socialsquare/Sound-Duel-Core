# app/client/highscore/highscores.coffee

# helpers

Template.highscores.helpers
  highscores: ->

    #TODO:
    # search_obj =
    #   score: { $gt: 0 }
    #   # state: { $eq: 'finished' }

    # # The `state == 'finished'` criteria is not used, because
    # #  1. When there's no games in the database Minimongo breaks on this query
    # #  2. Only finished games have a score greater than zero

    # if Session.get 'quizId'
    #   Games.find(
    #     score: { $gt: 0 }
    #     quizId: Session.get 'quizId'
    #   , { sort: [['score', 'desc']], limit: 20 })
    #   # Highscores.find(
    #   #   score: { $gt: 0 }
    #   #   quizId: Session.get 'quizId'
    #   # )
    # else
    #   null

    Highscores.find({}, { sort: [[ 'score', 'desc' ]], limit: 20 })
      .fetch().map (h) ->
        {
          name: h.name
          score: Games.findOne(h.gameId).score
        }

  quizzes: ->
    today = new Date()
    Quizzes.find(
      startDate: { $lt: today}
    ,
      sort: [['startDate', 'asc']]
    ).fetch()

Template.highscores.events
  # <select> change quiz
  'change ': (event) ->
    console.log '<select> changed'
    quizId = $('[data-sd-quiz-selector] option:selected').data('quiz-id')
    Session.set 'quizId', quizId
    console.log(Session.get 'quizId')

UI.registerHelper 'selectToday', (date) ->
  todayDate = new Date()
  if todayDate.setHours(0,0,0,0) == date.setHours(0,0,0,0)
    ' selected="selected"'
  else
    ''

UI.registerHelper 'displayDate', (date) ->
  months = ['januar', 'februar', 'marts', 'april', 'maj', 'juni', 'juli',
    'august', 'september', 'oktober', 'november', 'december']
  date.getDate() + '. ' + months[date.getMonth()]

UI.registerHelper 'withPosition', (cursor, options) ->
  cursor.map (element, i) ->
    element.position = i + 1
    element
