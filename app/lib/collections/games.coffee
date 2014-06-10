# app/client/lib/collections/games.coffee

@Games = new Meteor.Collection 'games'

# permission

Games.allow
  insert: (userId, doc) -> false

  update: (userId, doc, fields, modifier) -> true
    # allowedFields = [ 'answers', 'currentQuestion', 'state' ]
    # isAllowedFields = true
    # for f in fields
    #   unless f in allowedFields
    #     isAllowedFields = false

    # isGameOwner = userId == doc.playerId

    # res = isAllowedFields && isGameOwner

    # console.log "Game update:"
    # if res
    #   console.log "allowed"
    # else
    #   console.log "DENIED"
    # res

  remove: (userId, doc) -> false

# publish

if Meteor.isServer
  Meteor.publish 'games', ->
    Games.find() # TODO
