# app/lib/router.coffee

Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  # waitOn: ->
  #   [
  #     Meteor.subscribe 'currentUser'
  #     Meteor.subscribe 'users'
  #   ]


# filters

# Router._filters =

# filters = Router._filters


# client

if Meteor.isClient

  # before hooks

  Router.onBeforeAction 'loading'
  Router.onBeforeAction 'dataNotFound', only: 'game'


  # routes

  Router.map ->
    # lobby
    @route 'lobby',
      path: '/'

    # highscore
    @route 'highscores',
      waitOn: ->
        [
          Meteor.subscribe 'games'
          Meteor.subscribe 'quizzes'
        ]

    # quizzes (debug)
    @route 'quizzes',
      waitOn: -> Meteor.subscribe 'quizzes'

    # # quiz
    # @route 'quiz',
    #   path: '/quiz/:_id'

    #   waitOn: ->
    #     [
    #       Meteor.subscribe 'games'
    #       Meteor.subscribe 'quizzes'
    #       Meteor.subscribe 'questions'
    #       Meteor.subscribe 'sounds'
    #     ]

    #   data: ->
    #     Quizzes.findOne @params._id

    #   onRun: ->
    #     id = @params._id
    #     Deps.nonreactive ->
    #       Session.set 'currentQuizId', id

    #   onBeforeAction: (pause) ->
    #     quiz = @data()
    #     return unless quiz?

    #     # Check that the quiz has started and hasn't run out
    #     now = new Date()
    #     unless (quiz.startDate < now and now < quiz.endDate)
    #       @redirect 'lobby'
    #       FlashMessages.sendError 'Denne quiz er ikke tilgængelig'
    #       pause()
    #       return

    #     unless Session.get 'currentQuestion'
    #       Session.set 'currentQuestion', 0

    # game
    @route 'game',
      path: '/game/:_id/:action'

      waitOn: ->
        [
          Meteor.subscribe 'games'
          Meteor.subscribe 'quizzes'
          Meteor.subscribe 'questions'
          Meteor.subscribe 'sounds'
        ]

      data: -> Games.findOne @params._id

      onRun: ->
        id = @params._id
        Deps.nonreactive ->
          Session.set 'currentGameId', id

      onBeforeAction: (pause) ->
        unless @params.action in [ 'play', 'result' ]
          @render 'notFound'
          pause()

      action: ->
        @render @params.action
