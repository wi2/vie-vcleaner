 # Person.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =
  tableName: 'persons'
  attributes:
    localid: 'string'
    title: 'string'
    username: 'string'
    firstname: 'string'
    lastname: 'string'
    pole:
      model: 'pole'
    timesheet:
      model: 'timesheet'
