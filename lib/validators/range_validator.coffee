ValidationError = require('../error.coffee')

module.exports = class RangeValidator
  constructor: (@min, @max) ->

  test: (value) =>
    if value < @min || value > @max
      throw new ValidationError("Value #{value} is out of range [#{@min},#{@max}]", value, this)