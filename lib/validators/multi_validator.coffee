_ = require('../util.coffee')
ValidationError = require('../error.coffee')

Promise = require('promise')

module.exports = class MultiValidator
  constructor: (options = {}) ->
    @options = _.defaults options,
      async: false

    @validators = []

  async: => @options.async

  add: (validator) =>
    _.guardValidator(validator)
    @guardAsync(validator)

    @validators.push(validator)

  test: (value) =>
    if @async()
      @testAsync(value)
    else
      @testSync(value)

  testSync: (value) =>
    try
      for validator in @validators
        validator.test(value)
    catch err
      throw new ValidationError("", value, this)

  testAsync: (value) =>
    results = _.map @validators, (v) -> _.lift(v.test)(value)

    Promise.all(results)

  guardAsync: (validator) =>
    if validator.async?() == true && !@async()
      throw new Error("Can't add async validators into a sync MultiValitor, use the {sync: true} option to allow async validators to be added.")