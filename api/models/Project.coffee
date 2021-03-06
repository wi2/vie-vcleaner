 # Project.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =
  tableName: 'projects'
  attributes:
    localid: 'string'
    name: 'string'
    description: 'string'
    client_id:
      model: 'client'
    timesheets:
      collection: 'timesheet'
      via: 'project_id'