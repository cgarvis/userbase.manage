angular.module('userbase')
  .value('currentUser', {})

  .factory 'getApplication', (ApplicationDataStore) ->
    (id) ->
      ApplicationDataStore.get(id)

  .factory 'fetchApplications', (ApplicationDataStore) ->
    (owner) ->
      ApplicationDataStore.list(owner)

  .factory 'fetchUsers', (UserDataStore) ->
    (app) ->
      UserDataStore.list(app)

  .controller 'UsersCtrl', ($scope, $routeParams, $log, getApplication, fetchUsers) ->
    getApplication($routeParams.appId)
      .then (app) ->
        $scope.app = app
        fetchUsers(app)
      .then (users) ->
        $scope.users = users
      .catch (err) ->
        $log.debug('Failed to load app data', err)
