_ = require("./util.coffee")

ValidationError = require('./error.coffee')
MultiValidator = require('./multi_validator.coffee')

Promise = require('promise')

module.exports = class MultiAsyncValidator extends MultiValidator
  test: (value) =>
    results = _.map @validators, (v) -> _.lift(v.test)(value)

    Promise.all(results)