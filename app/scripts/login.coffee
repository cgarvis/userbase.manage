angular.module('userbase')
  .factory 'loginUser', ($q, $log, SessionDataStore, userbase, fetchProjects) ->
    (email, password) ->
      deferred = $q.defer()

      if email? and password?
        SessionDataStore.get({email: email, password: password}, userbase)
          .then (user) ->
            fetchProjects(user)
              .then (projects) ->
                deferred.resolve({user: user, project: projects[0]})
          .catch (err) ->
            deferred.reject(err)
      else
        deferred.reject('Email and password are required')

      deferred.promise

  .controller 'LoginCtrl', ($scope, $log, $location, loginUser) ->
    $scope.login = ->
      loginUser($scope.user.email, $scope.user.password)
        .then ({user, project}) ->
          $location.path("/#{project.id}/users")
        .catch (err) ->
          $log.warn('Failed to login user:', err)
