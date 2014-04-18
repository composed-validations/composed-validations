ValidationError = require('../error.coffee')

module.exports = class FormatValidator
  constructor: (@format) ->

  test: (value) =>
    unless @format.exec(value)
      throw new ValidationError("#{value} doesn't match with #{@format}")