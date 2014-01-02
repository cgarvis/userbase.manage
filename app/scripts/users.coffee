angular.module('userbase')
  .factory 'createUser', (UserDataStore) ->
    (email, password, project) ->
      UserDataStore.save({email: email, password: password}, project)

  .factory 'fetchUsers', (UserDataStore) ->
    (project) ->
      UserDataStore.list(project)

  .controller 'UsersCtrl', ($scope, $routeParams, $log, getProject, fetchUsers) ->
    refreshUsers = (project) ->
      fetchUsers(project)
        .then (users) ->
          $scope.users = users
        .catch (err) ->
          $log.debug('Failed to load project data', err)

    # Initial load projects and the users
    getProject($routeParams.projectId)
      .then (project) ->
        $scope.project = project

        # Refresh list when user is created
        $scope.$on('user:created', -> refreshUsers($scope.project))
        refreshUsers(project)

  .controller 'CreateUserCtrl', ($scope, $routeParams, $log, getProject, createUser) ->
    $scope.user = {}

    promise = getProject($routeParams.projectId)

    $scope.createUser = ->
      promise.then (project) ->
        createUser($scope.user.email, $scope.user.password, project)
          .then ->
            $scope.$emit('user:created')
            $scope.close()
