# app/client/lib/collections/games.coffee

@Games = new Meteor.Collection 'games'

# permission

Games.allow
  insert: (userId, doc) -> false

  update: (userId, doc, fields, modifier) ->
    allowedFields = [ 'answers', 'currentQuestion', 'state' ]

    for f in fields
      unless f in allowedFields
        return false

    true

  remove: (userId, doc) -> false

# publish

if Meteor.isServer
  Meteor.publish 'currentGame', (id) ->
    Games.find id
