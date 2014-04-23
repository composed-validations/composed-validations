_ = require('../util.coffee')
MultiValidator = require('./multi_validator.coffee')

Promise = require('promise')

module.exports = class SequenceValidator extends MultiValidator
  test: (value) =>
    if @async()
      @testAsync(value)
    else
      @testSync(value)

  testSync: (value) =>
    _.reduce @validators, value, (acc, validator) -> validator.test(acc)

  testAsync: (value) =>
    _.reduce @validators, Promise.from(value), (promise, validator) ->
      promise.then((acc) -> validator.test(acc))
