ValidationError = require('../errors/validation_error.coffee')

module.exports = class FormatValidator
  constructor: (@format) ->

  test: (value) =>
    unless @format.exec(value)
      throw new ValidationError("format is not valid", value, this)
