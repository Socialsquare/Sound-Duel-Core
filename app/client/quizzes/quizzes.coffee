# app/client/quizzes/quizzes.coffee

# methods

today = -> new Date()


# helpers

Template.quizzes.helpers
  quizzes: -> Quizzes.find()

Template.quizRow.helpers
  today: ->
    @startDate < today() and today() < @endDate


# events

Template.quizRow.events
  'click [data-sd-startDate]': ->
    Quizzes.update @_id, $set:
      startDate: today()

  'click [data-sd-endDate]': ->
    Quizzes.update @_id, $set:
      endDate: new Date(today().getTime() + 24*60*60*1000)
