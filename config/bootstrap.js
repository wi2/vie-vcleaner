/**
 * Bootstrap
 * (sails.config.bootstrap)
 *
 * An asynchronous bootstrap function that runs before your Sails app gets lifted.
 * This gives you an opportunity to set up your data model, run jobs, or perform some special logic.
 *
 * For more information on bootstrapping your app, check out:
 * http://sailsjs.org/#/documentation/reference/sails.config/sails.config.bootstrap.html
 */

module.exports.bootstrap = function(cb) {

  //cron : récupération des data
  var CronJob = require('cron').CronJob;
  var job = new CronJob({
    cronTime: '00 00 01 * * 1-5',//du lundi au vendredi à 1h
    onTick: function() {
      console.log("Cron start");
      return require('http').get({
          host: 'localhost',
          port: 1337,
          path: '/import'
      }, null);
    },
    start: false,
    timeZone: 'Europe/Paris'
  });
  job.start();



  // It's very important to trigger this callback method when you are finished
  // with the bootstrap!  (otherwise your server will never lift, since it's waiting on the bootstrap)
  cb();
};
