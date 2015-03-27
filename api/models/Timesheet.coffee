 # Timesheet.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =

  attributes:
    localid: 'string'
    time: 'integer'
    date: 'date'
    project:
      model: 'project'
    person:
      model: 'person'
    # minutes: 'integer'
