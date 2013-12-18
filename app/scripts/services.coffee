angular.module('userbase')
  .factory 'store', ->
    apps: {}
    next_app_id: 1
    users: {}
    next_user_id: 1
  .factory 'ApplicationDataStore', ($q, $log, store) ->
    get: (id) ->
      deferred = $q.defer()

      if store.apps[id]?
        deferred.resolve(store.apps[id])
      else
        deferred.reject('Not found')

      deferred.promise

    list: (owner) ->
      deferred = $q.defer()

      apps = (app for id, app of store.apps when app.owner_id is owner.id)
      deferred.resolve(apps)

      deferred.promise

    save: (app, owner) ->
      unless app.id?
        app.id = store.next_app_id
        store.next_app_id++
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

    list: (app) ->
      deferred = $q.defer()

      users = (user for id, user of store.users when user.app_id is app.id)
      deferred.resolve(users)

      deferred.promise

    save: (user, app) ->
      unless user.id?
        user.id = store.next_user_id
        store.next_user_id++
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
