ValidationError = require('../error.coffee')

module.exports = class NegateValidator
  constructor: (@validator) ->

  async: -> @validator.async?() || false

  test: (value) =>
    if @async()
      @testAsync(value)
    else
      @testSync(value)

  testAsync: (value) =>
    @validator.test(value).then(
      => @fail(value)
      => null
    )

  testSync: (value) =>
    try
      @validator.test(value)
    catch err
      return

    @fail(value)

  fail: (value) => throw new ValidationError("validation negated failed", value, this)