# app/client/lib/collections/games.coffee

@Games = new Meteor.Collection 'games'

# permission

Games.allow
  insert: (userId, doc) -> false

  update: (userId, doc, fields, modifier) -> false

  remove: (userId, doc) -> false

# publish

if Meteor.isServer
  Meteor.publish 'currentGame', (id) ->
    Games.find id
