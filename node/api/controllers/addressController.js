'use strict';

var RippleAPI = require('ripple-lib').RippleAPI;

exports.create = function(req, res) {
  var api = new RippleAPI();
  res.json(api.generateAddress());  
};
