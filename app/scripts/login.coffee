angular.module('userbase')
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

  .controller 'LoginCtrl', ($scope, $log, $location, loginUser) ->
    $scope.login = ->
      loginUser($scope.user.email, $scope.user.password)
        .then ->
          $location.path('/')
        .catch (err) ->
          $log.warn('Failed to login user:', err)
