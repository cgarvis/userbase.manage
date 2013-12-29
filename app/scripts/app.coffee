'use strict'

angular.module('userbase', [
  'ngCookies'
  'ngRoute'
  'modal'
])
  # @TODO: implement once grunt handles pustate
  #.config ($locationProvider) ->
  #  $locationProvider.html5Mode(true)

  .config ($routeProvider) ->
    $routeProvider
      .when '/:projectId/users',
        templateUrl: 'views/dashboard.html'
        controller: 'UsersCtrl'
      .when '/login',
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'
      .when '/register',
        templateUrl: 'views/register.html'
        controller: 'RegisterCtrl'

  .run ($window, ProjectDataStore, UserDataStore) ->
    $window.project_store = ProjectDataStore
    $window.user_store = UserDataStore

    userbase = null
    ProjectDataStore.save({name: 'Userbase'})
      .then (project) ->
        userbase = project
        UserDataStore.save({email: 'joe@userbase.io', password: 'password'}, userbase)
          .then (user) ->
            ProjectDataStore.save({name: 'Legal'}, user)
          .then (legal_project) ->
            UserDataStore.save({email: 'joe@legal.io', password: 'password'},legal_project)
            UserDataStore.save({email: 'sue@legal.io', password: 'password'},legal_project)
        UserDataStore.save({email: 'cgarvis@gmail.com', password: 'hitachi'}, userbase)
          .then (user) ->
            ProjectDataStore.save(userbase, user)
            ProjectDataStore.save({name: 'Simply Hitched'}, user)
          .then (hitched_project) ->
            UserDataStore.save({email: 'joe@hitched.io', password: 'password'}, hitched_project)
            UserDataStore.save({email: 'sue@hitched.io', password: 'password'}, hitched_project)

  .run ($rootScope, $location, Auth) ->
    $rootScope.$on '$routeChangeStart', (event, next, current) ->
      unless Auth.isLoggedIn() then $location.path('/login')

