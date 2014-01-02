angular.module('alerts', [])
  .directive 'alert', ->
    restrict:'EA'
    template: '''
      <div class='alert' ng-class='"alert-" + (type || "warning")'>
        <button ng-show='closeable' type='button' class='close' ng-click='close()'>&times;</button>
        <div ng-transclude></div>
      </div>
    '''
    transclude:true
    replace:true
    scope:
      type: '='
      close: '&'
    controller: ($scope, $attrs) ->
      $scope.closeable = 'close' of $attrs
