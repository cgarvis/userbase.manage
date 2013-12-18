angular.module('userbase')
  .factory 'loginUser', ($q, $log, SessionDataStore, userbase, fetchApplications) ->
    (email, password) ->
      deferred = $q.defer()

      if email? and password?
        SessionDataStore.get({email: email, password: password}, userbase)
          .then (user) ->
            fetchApplications(user)
              .then (apps) ->
                deferred.resolve({user: user, app: apps[0]})
          .catch (err) ->
            deferred.reject(err)
      else
        deferred.reject('Email and password are required')

      deferred.promise

  .controller 'LoginCtrl', ($scope, $log, $location, loginUser) ->
    $scope.login = ->
      loginUser($scope.user.email, $scope.user.password)
        .then ({user, app}) ->
          $location.path("/#{app.id}/users")
        .catch (err) ->
          $log.warn('Failed to login user:', err)
