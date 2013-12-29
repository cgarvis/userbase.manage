angular.module('userbase')
  .directive 'topHeader', ($log) ->
    restrict: 'E'
    replace: true
    templateUrl: 'views/header.html'
    controller: ($scope, $location, Auth, fetchProjects) ->
      updateProjects = ->
        fetchProjects({id: Auth.user.id})
          .then (projects) ->
            $scope.projects = projects
          .catch (err) ->
            $log.warn('Fetch Projects:', err)

      $scope.selectProject = (index) ->
        project = $scope.projects[index]
        $location.path("/#{project.id}/users")

      # Update project list when one is added
      $scope.$on 'project:created', -> updateProjects()

      # Initial load of projects for current user
      updateProjects()

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
