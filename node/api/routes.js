'use strict';

module.exports = function(app) {
  var address = require('./controllers/addressController');

  // generate Address
  app.route('/addresses')
    .post(address.create);

   var transaction = require('./controllers/transactionController');

  // sign transaction
  app.route('/transaction/sign')
    .post(transaction.sign);
};