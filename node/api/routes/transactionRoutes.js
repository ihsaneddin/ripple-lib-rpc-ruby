'use strict';

module.exports = function(app) {
  var transaction = require('../controllers/transactionController');

  // generate Address
  app.route('/transaction/sign')
    .post(transaction.sign);
};