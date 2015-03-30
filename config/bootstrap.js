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

var fs = require('fs');

module.exports.bootstrap = function(cb) {

  var checkLastImport = function() {
    fs.stat(".tmp/lastimport.txt", function(err,stats){
      if(err) {
        fs.writeFile(".tmp/lastimport.txt", "", function(err) {
          if(err) return console.log(err);
          importation();
          console.log("The file was created!");
        });
      } else {
        console.log(stats);
        if ( +stats.mtime.getTime() + (24*60*60*1000) < +(new Date()) ) {
          importation();
        }
      }


    });
  }

  var importation = function() {
    require('http').get({
        host: 'localhost',
        port: 1337,
        path: '/import'
    }, function(res){
      console.log("Finish import");
      fs.writeFile(".tmp/lastimport.txt", +new Date(), function(err) {
        if(err) return console.log(err);
        console.log("The file was saved!");
      });
    });
  }

  //cron : récupération des data
  var CronJob = require('cron').CronJob;
  var job = new CronJob({
    cronTime: '00 16 03 * * 1-5',//du lundi au vendredi à 1h
    onTick: function() {
      console.log("Cron start");
      return importation();
    },
    start: false,
    timeZone: 'Europe/Paris'
  });
  job.start();
  checkLastImport();


  // It's very important to trigger this callback method when you are finished
  // with the bootstrap!  (otherwise your server will never lift, since it's waiting on the bootstrap)
  cb();
};
