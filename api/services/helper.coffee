
module.exports.logger = (obj) ->
  console.log obj.clients.data.length, obj.clients.count
  console.log obj.persons.data.length, obj.persons.count
  console.log obj.projects.data.length, obj.projects.count
  console.log obj.times.data.length, obj.times.count
  console.log("THE END")


module.exports.cleaner = (Model, model, next) ->
  Model.destroy().exec (err) ->
    console.log(" #{model} cleaned")
    next()