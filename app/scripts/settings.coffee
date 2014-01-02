angular.module('userbase')
  .controller 'SettingsCtrl', ($scope, $routeParams, getProject, saveProject) ->
    $scope.closeAlert = ->
      delete $scope.alert

    $scope.saveProject = ->
      saveProject($scope.project)
        .then (project) ->
          $scope.alert =
            type: 'success'
            msg: 'Settings saved'
        .catch (err) ->
          $scope.alert =
            type: 'error'
            msg: 'Settings could not be saved'

    # Initial project
    getProject($routeParams.projectId)
      .then (project) ->
        $scope.project = project
      .catch (err) ->
        $scope.alert =
          type: 'error'
          msg: 'Settings could not be loaded'
