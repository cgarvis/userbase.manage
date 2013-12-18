angular.module('userbase')
  .directive 'topHeader', ($log) ->
    restrict: 'E'
    replace: true
    templateUrl: 'views/header.html'
    controller: ($scope, $location, $log, fetchApplications) ->
      fetchApplications({id: 2})
        .then (apps) ->
          $scope.apps = apps
        .catch (err) ->
          $log.warn('Fetch Applications:', err)

      $scope.select = (index) ->
        app = $scope.apps[index]
        $location.path("/#{app.id}/users")

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
