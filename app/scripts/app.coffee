'use strict'

angular.module('userbase', [
  'ngRoute'
])
  # @TODO: implement once grunt handles pustate
  #.config ($locationProvider) ->
  #  $locationProvider.html5Mode(true)

  .config ($routeProvider) ->
    $routeProvider
      .when '/login',
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'
      .when '/register',
        templateUrl: 'views/register.html'
        controller: 'RegisterCtrl'
      .otherwise
        redirectTo: '/register'
