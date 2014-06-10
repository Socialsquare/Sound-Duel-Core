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
