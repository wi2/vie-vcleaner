

angular.module "table", ['ui.router', 'ngSails']

.config [ '$stateProvider', '$urlRouterProvider', ( $stateProvider, $urlRouterProvider) ->

  #
  $urlRouterProvider.otherwise("/");

  $stateProvider
  .state 'receiver',
    url: "/"
    templateUrl: "templates/receiver.html"
    controller: 'receiverCtrl'

  .state 'emitter',
    url: "/emitter"
    templateUrl: "templates/emitter.html"
    controller: 'emitterCtrl'




]
