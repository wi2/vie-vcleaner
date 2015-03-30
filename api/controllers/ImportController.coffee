 # ImportController
 #
 # @description :: Server-side logic for managing imports
 # @help        :: See http://links.sailsjs.org/docs/controllers

 # TimesheetController
 #
 # @description :: Server-side logic for managing timesheets
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =
  import: (req, res) ->
    console.log "import Ctrl"
    allitems = {}

    async.series [
      (next) ->
        console.log("===== LOAD CLIENT ====")
        next()
      (next) ->
        timetask 'client', null, (result) ->
          allitems.clients =
            count: result.count
            data: []
          async.mapSeries result.items
          , (item, cb) ->
            item.iid = item.id
            delete item.id
            Client.findOrCreate { where: { localid: item.localid }}, item, (err, created) ->
              console.log created.name, created.id
              allitems.clients.data.push created
              cb()
          , next

      (next) ->
        console.log("===== LOAD PEOPLE ====")
        next()
      (next) ->
        timetask 'person', {active: true}, (result) ->
          allitems.persons = count: result.count
          allitems.persons.data = []
          async.mapSeries result.items
          , (item, cb) ->
            item.iid = item.id
            delete item.id
            Person.findOrCreate { where: { localid: item.localid }}, item, (err, created) ->
              console.log created.firstname, created.lastname, created.id
              allitems.persons.data.push created
              cb()
          , next

      (next) ->
        console.log("===== LOAD PROJECT ====")
        next()
      (next) ->
        timetask 'project', {active: true}, (result) ->
          allitems.projects =
            count: result.count
            data: []
          async.mapSeries result.items
          , (item, cb) ->
            find = _.findWhere allitems.clients.data, iid: item.clientid
            if (find)
              item.iid = item.id
              delete item.id
              delete item.client
              item.client = find.id
              Project.findOrCreate { where: { localid: item.localid }}, item, (err, created) ->
                console.log created.name, created.id
                allitems.projects.data.push created
                cb()
            else
              console.log "no client for this project #{item.name} (#{item.localid})"
              cb()
          , next

      (next) ->
        console.log("===== LOAD TIMESHEET ====")
        next()
      (next) ->
        timetask 'time', {limit: 75000, datebegin: "2014-01-01"}, (result) ->
          console.log('time', result.count)
          allitems.times =
            count: result.count
            data: []
          async.mapSeries result.items
          , (item, cb) ->
            find = _.findWhere allitems.projects.data, iid: item.projectid
            findPerson = _.findWhere allitems.persons.data, iid: item.personid
            if (find && findPerson)
              item.iid = item.id
              delete item.id
              delete item.project
              delete item.person
              item.project = find.id
              item.person = findPerson.id
              Timesheet.findOrCreate { where: { iid: item.iid }}, item, (err, created) ->
                console.log created.firstname, created.lastname, created.id, created.project, created.person
                allitems.times.data.push created
                cb()
            else
              console.log "not find this project"
              cb()
          , next

      (next) ->
        helper.logger allitems
        next()
    ]
    res.ok()
