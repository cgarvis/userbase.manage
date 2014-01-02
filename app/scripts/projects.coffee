angular.module('userbase')
  .factory 'createProject', ($q, ProjectDataStore) ->
    (name, owner) ->
      deferred = $q.defer()

      if name?
        new_project = {name: name}
        ProjectDataStore.save(new_project, owner)
          .then (project) ->
            deferred.resolve(project)
          .catch (err) ->
            deferred.reject(err)
      else
        deferred.reject('Name is required')

      deferred.promise

  .factory 'getProject', (ProjectDataStore) ->
    (id) ->
      ProjectDataStore.get(id)

  .factory 'fetchProjects', (ProjectDataStore) ->
    (owner) ->
      ProjectDataStore.list(owner)

  .factory 'saveProject', ($q, ProjectDataStore) ->
    (project) ->
      ProjectDataStore.save(project)

  .controller 'CreateProjectCtrl', ($scope, $log, createProject, Auth) ->
    $scope.project = {}

    $scope.createProject = ->
      createProject($scope.project.name, Auth.user)
        .then ->
          $scope.$emit('project:created')
          $scope.close()
        .catch (err) ->
          $log.warn('Failed to create project:', err)
