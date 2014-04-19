ValidationError = require('../error.coffee')

module.exports = class MultiValidator
  constructor: ->
    @validators = []

  add: (validator) =>
    if validator.async?() == true
      throw new Error("Can't add async validators into the MultiValidator, use the MultiAsyncValidator instead.")

    @validators.push(validator)

  test: (object) =>
    for validator in @validators
      validator.test(object)