angular.module('userbase')
  .factory 'Auth', ($cookieStore, $q, $log, SessionDataStore, userbase) ->
    currentUser = $cookieStore.get('user')
    console.log(currentUser)

    isLoggedIn: ->
      if @user? and @user.token?
        true
      else
        false

    login: (email, password) ->
      deferred = $q.defer()

      if email? and password?
        SessionDataStore.get({email: email, password: password}, userbase)
          .then (user) ->
            $cookieStore.put('user', user)
            angular.extend(@user, user)
            deferred.resolve(user)
          .catch (err) ->
            deferred.reject(err)
      else
        deferred.reject('Email and password are required')

      deferred.promise
    user: currentUser

  .controller 'LoginCtrl', ($scope, $log, $location, Auth, fetchProjects) ->
    $scope.login = ->
      Auth.login($scope.user.email, $scope.user.password)
        .then (user) ->
          fetchProjects(user)
        .then (projects) ->
          $location.path("/#{projects[0].id}/users")
        .catch (err) ->
          $log.warn('Failed to login user:', err)
