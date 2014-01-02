angular.module('userbase')
  .directive 'topHeader', ($log) ->
    restrict: 'E'
    replace: true
    templateUrl: 'views/header.html'
    controller: ($scope, $route, $location, Auth, fetchProjects) ->
      refreshProjects = ->
        fetchProjects({id: Auth.user.id})
          .then (projects) ->
            $scope.projects = projects
          .then ->
            selectProject()
          .catch (err) ->
            $log.warn('Fetch Projects:', err)

      selectProject = ->
        for project in $scope.projects
          if $route.current.params.projectId is project.id.toString()
            $scope.currentProject = project
            break

      $scope.currentUser = Auth.user

      $scope.switchProject = (index) ->
        $scope.currentProject = $scope.projects[index]
        $location.path("/#{$scope.currentProject.id}/users")

      # Update project list when one is added
      $scope.$on 'project:created', -> refreshProjects()

      # Initial load of projects for current user
      refreshProjects()

  .directive 'dropdownToggle', ($document, $location) ->
    openElement = null
    closeMenu = angular.noop

    restrict: 'CA'
    link: (scope, element, attrs) ->
      scope.$watch '$location.path', -> closeMenu()
      element.parent().bind 'click', -> closeMenu()
      element.bind 'click', (event) ->
        elementWasOpen = (element is openElement)

        event.preventDefault()
        event.stopPropagation()

        if openElement?
          closeMenu()

        if not elementWasOpen and not element.hasClass('disabled') and not element.prop('disabled')
          element.parent().addClass('open')
          openElement = element
          closeMenu = (event) ->
            if event
              event.preventDefault()
              event.stopPropagation()
            $document.unbind('click', closeMenu)
            element.parent().removeClass('open')
            closeMenu = angular.noop
            openElement = null
          $document.bind('click', closeMenu)
