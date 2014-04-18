_ = require('lodash')

ValidationError = require('./error.coffee')

module.exports = class IncludeValidator
  constructor: (@possibilities) ->

  test: (value) =>
    unless _.contains(@possibilities, value)
      throw new ValidationError("#{value} is not included on the list #{@possibilities}", this)