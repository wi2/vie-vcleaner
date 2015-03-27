tt = require 'machinepack-timetask'

module.exports = (model, params, cb) ->

  connection =
    model: model
    params: params||{}

  _.assign connection, sails.config.timetask

  tt.get connection
    .exec
      error: (err) -> console.log err
      success: (result) -> cb(result)
