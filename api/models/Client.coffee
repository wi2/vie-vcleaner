 # Client.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =
  tableName: 'clients'
  attributes:
    localid: 'string'
    name: 'string'
    projects:
      collection: 'project'
      via: 'client'
