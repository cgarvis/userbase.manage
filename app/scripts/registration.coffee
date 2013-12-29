angular.module('userbase')
  .factory 'userbase', ($log, ProjectDataStore) ->
    userbase = {}

    ProjectDataStore.get(1)
      .then (project) ->
        angular.extend(userbase, project)
      .catch (err) ->
        $log.error('Could not load Userbase Project data', err)

    userbase

  .factory 'createUser', ($q, UserDataStore) ->
    (email, password, project) ->
      deferred = $q.defer()

      if email? and password?
        new_user = {email: email, password: password}
        UserDataStore.save(new_user, project)
          .then (user) ->
            deferred.resolve(user)
          .catch (err) ->
            deferred.reject(err)
      else
        deferred.reject('Email and password are required')

      deferred.promise

  .factory 'registerUser', ($q, userbase, createUser, createProject) ->
    (email, password) ->
      deferred = $q.defer()

      # Get these out of the scope
      user = null

      createUser(email, password, userbase)
        .then (new_user) ->
          user = new_user
          createProject('New Project', user)
        .then (new_project) ->
          deferred.resolve(user, new_project)
        .catch (err) ->
          deferred.reject(err)

      deferred.promise

  .controller 'RegisterCtrl', ($scope, $location, $log, registerUser, loginUser) ->
    $scope.register = ->
      registerUser($scope.user.email, $scope.user.password)
        .then (user, project) ->
          $log.debug('Registered user')
          loginUser($scope.user.email, $scope.user.password)
        .then ->
          $location.path('/')
        .catch (err) ->
          $log.warn('Failed to complete registration:', err)

