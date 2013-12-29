angular.module('userbase')
  .factory 'getProject', (ProjectDataStore) ->
    (id) ->
      ProjectDataStore.get(id)

  .factory 'fetchProjects', (ProjectDataStore) ->
    (owner) ->
      ProjectDataStore.list(owner)

  .factory 'createUser', (UserDataStore) ->
    (email, password, project) ->
      UserDataStore.save({email: email, password: password}, project)

  .factory 'fetchUsers', (UserDataStore) ->
    (project) ->
      UserDataStore.list(project)

  .controller 'UsersCtrl', ($scope, $routeParams, $log, getProject, fetchUsers) ->
    updateUsers = (project) ->
      fetchUsers(project)
        .then (users) ->
          $scope.users = users
        .catch (err) ->
          $log.debug('Failed to load project data', err)

    promse = getProject($routeParams.projectId)
      .then (project) ->
        $scope.project = project

        $scope.$on('user:created', -> updateUsers($scope.project))
        updateUsers(project)

  .controller 'CreateUserCtrl', ($scope, $routeParams, $log, getProject, createUser) ->
    $scope.user = {}

    promise = getProject($routeParams.projectId)

    $scope.createUser = ->
      promise.then (project) ->
        createUser($scope.user.email, $scope.user.password, project)
          .then ->
            $scope.$emit('user:created')
            $scope.close()
