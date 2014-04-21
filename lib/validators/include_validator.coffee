_ = require("../util.coffee")
ValidationError = require('../errors/validation_error.coffee')

module.exports = class IncludeValidator
  constructor: (@possibilities) ->

  test: (value) =>
    unless _.contains(@possibilities, value)
      throw new ValidationError("#{_.json value} is not included on the list #{_.json @possibilities}", value, this)
