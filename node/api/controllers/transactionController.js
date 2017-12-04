'use strict';

var RippleAPI = require('ripple-lib').RippleAPI;

exports.sign = function(req, res) {
  var api = new RippleAPI();
  var txJson = JSON.stringify(req.body.txJson);
  var secret = req.body.secret;
  try {
    res.json(api.sign(txJson, secret));
  } catch (ValidationError) {
    res.status(422).send({ "error": "Unprocessable entity", "status": 422, "message": "Invalid params!" });   
  }  
};
