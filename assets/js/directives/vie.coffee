angular.module "table"
.directive 'vie',[ '$timeout', '$window', '$sails', ($timeout, $window, $sails) ->
  scope: true
  link: (scope, elem, attrs) ->

    $sails.get "/subscribe"

    $sails.on "logged_in", (message) -> console.log message
    $sails.on "count", (message) -> scope.order "count"
    $sails.on "group", (message) -> scope.order "group"
    $sails.on "name", (message) -> scope.order "name"

    scope.current =
      x: null
      y: null

    scope.cells = []


    $sails.on "test", (message) ->
      if message.pos >= 0
        if message.pos == scope.current.x
          scope.current.x = null
          scope.current.lock = 'y'
        else if message.pos == scope.current.y
          scope.current.y = null
          scope.current.lock = 'x'
        else if scope.current.lock
          if scope.current.lock == 'x'
            scope.current.y = message.pos
          else if scope.current.lock == 'y'
            scope.current.x = message.pos
        else
          scope.current.x = message.pos
          scope.current.lock = 'x'


      d3
      .selectAll(".row text")
      .classed "active", (d, i) -> i == scope.current.y

      d3
      .selectAll(".column text")
      .classed "active", (d, i) -> i == scope.current.x

      d3
      .selectAll(".row rect")
      .classed "active", (d, i) -> d.x == scope.current.x and d.y == scope.current.y


    # $sails.on "test", (message) ->
    #   if message.x
    #     scope.current.x = message.x
    #     scope.textsX[0].forEach (item) ->
    #       angular.element(item).removeClass 'active'
    #     angular.element(scope.textsX[0][message.x]).addClass 'active'

    #   if message.y
    #     scope.current.y = message.y
    #     scope.textsY[0].forEach (item) ->
    #       angular.element(item).removeClass 'active'
    #     angular.element(scope.textsY[0][message.y]).addClass 'active'

    #   d3.selectAll(".row rect").classed "active", (d, i) -> d.x == scope.current.x and d.y == scope.current.y


    win =
      width: $window.document.body.offsetWidth - 80
      height: $window.document.body.offsetHeight - 80
    d3 = $window.d3

    margin =
      top: 100
      right: 0
      bottom: 0
      left: 100
    width = win.height
    height = win.height




    x = d3.scale.ordinal().rangeBands([0, width])
    z = d3.scale.linear().domain([0, 4]).clamp(true)
    c = d3.scale.category10().domain(d3.range(10))

    svg = d3.select("body").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    # .style("margin-left", -margin.left + "px")
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")


    d3.json "vie.json", (vie) ->
      matrix = []
      scope.nodes = vie.nodes
      n = scope.nodes.length

      scope.nodes.forEach (node, i) ->
        node.index = i
        node.count = 0
        matrix[i] = d3.range(n).map (j) -> {x: j, y: i, z: 0}
        console.log node

      vie.links.forEach (link) ->
        # console.log link
        matrix[link.source][link.target].z += link.value
        matrix[link.target][link.source].z += link.value
        matrix[link.source][link.source].z += link.value
        matrix[link.target][link.target].z += link.value
        scope.nodes[link.source].count += link.value
        scope.nodes[link.target].count += link.value


      scope.orders =
        name: d3.range(n).sort (a, b) -> d3.ascending scope.nodes[a].name, scope.nodes[b].name
        count: d3.range(n).sort (a, b) -> scope.nodes[b].count - scope.nodes[a].count
        group: d3.range(n).sort (a, b) -> scope.nodes[b].group - scope.nodes[a].group

      x.domain scope.orders.name

      svg.append("rect")
      .attr("class", "background")
      .attr("width", width)
      .attr("height", height)

      row = svg.selectAll(".row")
      .data(matrix)
      .enter().append("g")
      .attr("class", "row")
      .attr("transform", (d, i) -> "translate(0," + x(i) + ")")
      .each(scope.row)

      row.append("line").attr("x2", width)

      scope.textsY = row.append("text")
      .attr("x", -6)
      .attr("y", x.rangeBand() / 2)
      .attr("dy", ".32em")
      .attr("text-anchor", "end")
      .text (d, i) -> scope.nodes[i].name

      column = svg.selectAll(".column")
      .data(matrix)
      .enter().append("g")
      .attr("class", "column")
      .attr "transform", (d, i) -> "translate(" + x(i) + "),rotate(-90)"

      column.append("line").attr("x1", -width)

      scope.textsX = column.append("text")
      .attr("x", 6)
      .attr("y", x.rangeBand() / 2)
      .attr("dy", ".32em")
      .attr("text-anchor", "start")
      .text (d, i) -> scope.nodes[i].name

      scope.interface()

    scope.row = (row) ->

      cell = d3.select(this).selectAll(".cell")
      .data row.filter (d) -> d.z
      .enter().append("rect")
      .attr("class", "cell")
      .attr "x", (d) -> x(d.x)
      .attr("width", x.rangeBand())
      .attr("height", x.rangeBand())
      .style "fill-opacity", (d) -> d.z / 100 * 4


    scope.order = (value) ->
      x.domain(scope.orders[value])
      t = svg.transition().duration(2500)

      t.selectAll(".row")
      .delay (d, i) -> x(i) * 4
      .attr "transform", (d, i) -> "translate(0," + x(i) + ")"
      .selectAll(".cell")
      .delay (d) -> x(d.x) * 4
      .attr "x", (d) -> x(d.x)

      t.selectAll(".column")
      .delay (d, i) -> x(i) * 4
      .attr "transform", (d, i) -> "translate(" + x(i) + ")rotate(-90)"


    scope.interface = () ->
      ratio = 1/4.7

      ipaddim =
        real:
          width: 950
          height: 700
        simul:
          width: (ratio * win.width)
          height: 700 * (ratio * win.width) / 950

      contour = angular.element '<div id="contour" class="contour"></div>'
      titre = angular.element '<h4 align="center">Organiser par</h4>'

      ipad = angular.element '<div id="ipad" class="ipad"></div>'
      ipad.css
        width: ipaddim.simul.width + 'px'
        height: ipaddim.simul.height + 'px'

      elem.append contour
      contour.append titre
      contour.append ipad

      factBtns = []
      factBtns.push ipad.append "<button class='btn fact'>Noms</button>"
      factBtns.push ipad.append "<button class='btn fact'>Pôles</button>"
      factBtns.push ipad.append "<button class='btn fact'>Temps</button>"

      factImgs = []

      scope.nodes.forEach (p) ->
        factImgs.push ipad.append '<img src="http://af83.com/uploads/person/image/35/thumb_Etienne.png" class="personFact" alt="'+p.name+'">'



]