 # Timesheet.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =
  tableName: 'timesheets'
  attributes:
    localid: 'string'
    time: 'integer'
    date: 'date'
    project_id:
      model: 'project'
    person_id:
      model: 'person'
    # minutes: 'integer'
