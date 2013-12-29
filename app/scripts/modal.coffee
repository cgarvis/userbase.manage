angular.module('modal', [])
  .directive 'modalWindow', ($log) ->
    restrict: 'E'
    templateUrl: (element, attr) ->
      if attr.template?
        attr.template
      else
        $log.warn('TemplateUrl not set for modal')
    link: (scope, element, attr) ->
      # needed to work with bootstrap
      angular.element(element.children()[0]).css('display', 'block')

      scope.close = ->
        element.remove()
        element.null

  .directive 'modal', ($compile, $log) ->
    scope:
      template: '@modal'
    link: (scope, element, attrs) ->
      element.on 'click', ->
        scope.open()

      scope.open = ->
        html = "<modal-window template=\"#{scope.template}\"></modal-window>"
        content = angular.element(html)
        angular.element(document.body).prepend(content)
        $compile(content)(scope)

