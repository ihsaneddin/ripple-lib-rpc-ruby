var express = require('express'),
  app = express(),
  port = process.env.PORT || 52134;

  bodyParser = require('body-parser');

  app.use(bodyParser.urlencoded({ extended: true }));
  app.use(bodyParser.json());

  var routes = require('./api/routes'); //importing route
  routes(app); 

app.listen(port);

console.log('Simple Rest RippleLib API started on: ' + port);
