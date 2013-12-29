angular.module('userbase')
  .factory 'store', ->
    projects: {}
    next_project_id: 1
    users: {}
    next_user_id: 1
  .factory 'ProjectDataStore', ($q, $log, store) ->
    get: (id) ->
      deferred = $q.defer()

      if store.projects[id]?
        deferred.resolve(store.projects[id])
      else
        deferred.reject('Not found')

      deferred.promise

    list: (owner) ->
      deferred = $q.defer()

      projects = (project for id, project of store.projects when project.owner_id is owner.id)
      deferred.resolve(projects)

      deferred.promise

    save: (project, owner) ->
      unless project.id?
        project.id = store.next_project_id
        store.next_project_id++
      if owner?
        project.owner_id = owner.id

      store.projects[project.id] = project
      $log.debug('Project created', project)
      $q.when(project)

  .factory 'UserDataStore', ($q, $log, store) ->
    get: (id) ->
      deferred = $q.defer()

      if store.users[id]?
        deferred.resolve(store.users[id])
      else
        deferred.reject('Not found')

      deferred.promise

    list: (project) ->
      deferred = $q.defer()

      users = (user for id, user of store.users when user.project_id is project.id)
      deferred.resolve(users)

      deferred.promise

    save: (user, project) ->
      unless user.id?
        user.id = store.next_user_id
        store.next_user_id++
      if project?
        user.project_id = project.id
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
