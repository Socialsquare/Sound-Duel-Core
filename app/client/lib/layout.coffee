# app/client/utils/layout.coffee

# helpers

UI.registerHelper 'active', (route) ->
  currentRoute = Router.current()
  return '' unless currentRoute

  if currentRoute.route.name == route
    'active'
  else
    ''

Template.navbar.helpers
  externallink: -> 'http://www.dr.dk/sporten/fifavm2014'

# Template.currentUser.helpers
#   name: ->
#     Meteor.user().profile.name
