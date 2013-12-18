angular.module('userbase')
  .factory 'store', ->
    apps: []
    users: []
  .factory 'ApplicationDataStore', ($q, $log, store) ->
    get: (id) ->
      deferred = $q.defer()

      if store.apps[id]?
        deferred.resolve(store.apps[id])
      else
        deferred.reject('Not found')

      deferred.promise

    save: (app, owner) ->
      unless app.id?
        app.id = store.apps.length + 1
      if owner?
        app.owner_id = owner.id

      store.apps[app.id] = app
      $log.debug('Application created', app)
      $q.when(app)

  .factory 'UserDataStore', ($q, $log, store) ->
    get: (id) ->
      deferred = $q.defer()

      if store.users[id]?
        deferred.resolve(store.users[id])
      else
        deferred.reject('Not found')

      deferred.promise

    save: (user, app) ->
      unless user.id?
        user.id = store.users.length + 1
      if app?
        user.app_id = app.id
      store.users[user.id] = user
      $log.debug('User created', user)
      $q.when(user)

  .factory 'SessionDataStore', ($q, $log, store) ->
    get: ({email, password}) ->
      deferred = $q.defer()

      for id, user of store.users
        if user.email is email
          found = true
          if user.password is password
            session = {id: user.id, email: user.email}
            $log.debug('User logged in', session)
            deferred.resolve(session)
          else
            $log.debug('Failed to login user')
            deferred.reject('Password does not match')

      unless found
        deferred.reject('User not found')

      deferred.promise
