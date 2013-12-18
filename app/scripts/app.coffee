'use strict'

angular.module('userbase', [
  'ngRoute'
])
  # @TODO: implement once grunt handles pustate
  #.config ($locationProvider) ->
  #  $locationProvider.html5Mode(true)

  .config ($routeProvider) ->
    $routeProvider
      .when '/:appId/users',
        templateUrl: 'views/dashboard.html'
        controller: 'UsersCtrl'
      .when '/login',
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'
      .when '/register',
        templateUrl: 'views/register.html'
        controller: 'RegisterCtrl'
      .otherwise
        redirectTo: '/login'

  .run (ApplicationDataStore, UserDataStore) ->
    userbase = null
    ApplicationDataStore.save({name: 'Userbase'})
      .then (app) ->
        userbase = app
        UserDataStore.save({email: 'joe@userbase.io', password: 'password'}, userbase)
          .then (user) ->
            ApplicationDataStore.save({name: 'Legal'}, user)
          .then (legal_app) ->
            UserDataStore.save({email: 'joe@legal.io', password: 'password'},legal_app)
            UserDataStore.save({email: 'sue@legal.io', password: 'password'},legal_app)
        UserDataStore.save({email: 'cgarvis@gmail.com', password: 'hitachi'}, userbase)
          .then (user) ->
            ApplicationDataStore.save(userbase, user)
            ApplicationDataStore.save({name: 'Simply Hitched'}, user)
          .then (hitched_app) ->
            UserDataStore.save({email: 'joe@hitched.io', password: 'password'}, hitched_app)
            UserDataStore.save({email: 'sue@hitched.io', password: 'password'}, hitched_app)
