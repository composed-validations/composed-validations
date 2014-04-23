_ = require('../util.coffee')

MultiValidationError = require('../errors/multi_validation_error.coffee')

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

    this

  test: (value) =>
    @multiTest value, (errors) =>
      throw new MultiValidationError("You have error(s) on your data:", value, this, errors) if errors.length > 0

      value

  multiTest: (value, handler) =>
    if @async()
      @testAsync(value).then(handler)
    else
      handler(@testSync(value))

  testSync: (value) =>
    errors = []

    for validator in @validators
      try
        validator.test(value)
      catch err
        _.guardValidationError(err)
        errors.push(err)

    errors

  testAsync: (value) =>
    errors = []

    results = _.map @validators, (v) =>
      _.lift((value) -> v.test(value))(value).then(
        undefined
        (err) =>
          _.guardValidationError(err)
          errors.push(err)
          null
      )

    Promise.all(results).then -> errors

  guardAsync: (validator) =>
    if validator.async?() == true && !@async()
      throw new Error("Can't add async validators into a sync MultiValitor, use the {sync: true} option to allow async validators to be added.")
