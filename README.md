## Projet interne d'AF83 - aspiration de données d'interval

Projet VIE - Versatile interactive experience / Internal Vaccuum Cleaner
Simple aspiration des données via l'API d'Interval


### Prérequis
node v 0.10 / 0.12
mongo

### Installation :
```
npm install
```

créer un fichier config/timetask.js
```

module.exports.timetask = {
  account: 'account_name',
  token: 'your_token'
};

```

### Pour démarrer le serveur :

```
sails lift
```

### pour lancer un import:

soit par le navigateur
```
http://localhost:1337/import
```
ou dans la console (nouvelle)
```
curl http://localhost:1337/import

```

### API
Get all persons : ```http://localhost:1337/person```

Get all clients : ```http://localhost:1337/client```

Get all times : ```http://localhost:1337/timesheet```

Get all projects : ```http://localhost:1337/project```


a [Sails](http://sailsjs.org) application



