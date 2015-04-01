angular.module "table"

.controller "emitterCtrl", ['$scope', '$sails', '$http', ($scope, $sails, $http) ->
  $scope.buttons = [
    {id: 1, label: "count", title:"count", action: "count"},
    {id: 2, label: "group", title:"group", action: "group"},
    {id: 3, label: "name", title:"name", action: "name"},
    # {id: 4, label: "opopopo", title:"opopop", action: "test", x:1, y:0},
    # {id: 5, label: "opopopo", title:"opopop", action: "test", x:10, y:1},
    # {id: 6, label: "opopopo", title:"opopop", action: "test", x:11, y:2},
    # {id: 7, label: "opopopo", title:"opopop", action: "test", x:12, y:3}
  ]

  $scope.persons = []

  $http.get "/vie.json"
  .success (data, status, headers, config) ->
    $scope.persons = data.nodes.map (item) -> item.name
    console.log $scope.persons
  .error (data, status, headers, config) ->
    console.log  "AJAX failed!"

  $sails.get "/subscribe"
  $sails.on "logged_in", (message) -> console.log message


  $scope.addMessage = (id) ->
    for butt in $scope.buttons
      if butt.id == id
        $sails.post '/emitter', {action: butt.action}



  $scope.light = (pos) ->
    $sails.post '/emitter', {action: "test", pos:pos||0}

  $scope.addMessageX = (nx) ->
    $sails.post '/emitter', {action: "test", x:nx||0}

  $scope.addMessageY = (ny) ->
    $sails.post '/emitter', {action: "test", y:ny||0}


]

.controller "receiverCtrl", ['$scope', '$sails', ($scope, $sails) ->

]
