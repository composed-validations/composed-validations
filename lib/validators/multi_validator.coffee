_ = require('../util.coffee')
ValidationError = require('../error.coffee')

module.exports = class MultiValidator
  constructor: (validators = []) ->
    @validators = []

    @add(v) for v in validators

    null

  async: => false

  add: (validator) =>
    _.guardValidator(validator)

    if validator.async?() == true && !@async()
      throw new Error("Can't add async validators into the MultiValidator, use the MultiAsyncValidator instead.")

    @validators.push(validator)

  test: (object) =>
    try
      for validator in @validators
        validator.test(object)
    catch err
      throw new ValidationError("", object, this)