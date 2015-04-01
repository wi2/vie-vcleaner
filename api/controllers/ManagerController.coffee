 # ManagerController
 #
 # @description :: Server-side logic for managing managers
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =
  emitter: (req, res) ->
    console.log "Emit Ctrl"
    params = req.allParams()

    sails.sockets.blast(params.action, params, req.socket)
    res.ok()

  subscribe: (req, res) ->
    console.log "Subscribe Ctrl"
    unless req.isSocket
      res.badRequest()
    else
      console.log req.socket
      sails.sockets.blast 'logged_in', {msg: 'person just logged in.'}, req.socket

