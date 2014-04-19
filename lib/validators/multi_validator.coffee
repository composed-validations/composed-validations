ValidationError = require('../error.coffee')

module.exports = class MultiValidator
  constructor: ->
    @validators = []

  async: -> false

  add: (validator) =>
    if validator.async?() == true && !@async()
      throw new Error("Can't add async validators into the MultiValidator, use the MultiAsyncValidator instead.")

    @validators.push(validator)

  test: (object) =>
    try
      for validator in @validators
        validator.test(object)
    catch err
      throw new ValidationError("", object, this)