_ = require('lodash')

ValidationError = require('./error.coffee')

module.exports = class MultiValidator
  constructor: ->
    @validators = []

  add: (validator) => @validators.push(validator)

  test: (object) =>
    for validator in @validators
      validator.test(object)