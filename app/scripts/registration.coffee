angular.module('userbase')
  .factory 'userbase', ($log, ApplicationDataStore) ->
    userbase = {}

    ApplicationDataStore.get(1)
      .then (app) ->
        angular.extend(userbase, app)
      .catch (err) ->
        ApplicationDataStore.save({name: 'Userbase'})
      .then (app) ->
        angular.extend(userbase, app)

    userbase

  .factory 'createUser', ($q, UserDataStore) ->
    (email, password, application) ->
      deferred = $q.defer()

      if email? and password?
        new_user = {email: email, password: password}
        UserDataStore.save(new_user, application)
          .then (user) ->
            deferred.resolve(user)
          .catch (err) ->
            deferred.reject(err)
      else
        deferred.reject('Email and password are required')

      deferred.promise

  .factory 'createApplication', ($q, ApplicationDataStore) ->
    (name, owner) ->
      deferred = $q.defer()

      if name?
        new_app = {name: name}
        ApplicationDataStore.save(new_app, owner)
          .then (app) ->
            deferred.resolve(app)
          .catch (err) ->
      else
        deferred.reject('Name is required')

      deferred.promise

  .factory 'registerUser', ($q, userbase, createUser, createApplication) ->
    (email, password) ->
      deferred = $q.defer()

      # Get these out of the scope
      user = null

      createUser(email, password, userbase)
        .then (new_user) ->
          user = new_user
          createApplication('New Project', user)
        .then (new_app) ->
          deferred.resolve(user, new_app)
        .catch (err) ->
          deferred.reject(err)

      deferred.promise

  .factory 'loginUser', ($q, SessionDataStore, userbase) ->
    (email, password) ->
      deferred = $q.defer()

      if email? and password?
        SessionDataStore.get({email: email, password: password}, userbase)
          .then (user) ->
            deferred.resolve(user)
          .catch (err) ->
            deferred.reject(err)
      else
        deferred.reject('Email and password are required')

      deferred.promise

  .controller 'RegisterCtrl', ($scope, $location, $log, registerUser, loginUser) ->
    $scope.register = ->
      registerUser($scope.user.email, $scope.user.password)
        .then (user, app) ->
          $log.debug('Registered user')
          loginUser($scope.user.email, $scope.user.password)
        .then ->
          $location.path('/')
        .catch (err) ->
          $log.warn('Failed to complete registration:', err)

