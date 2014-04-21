_ = require('../util.coffee')
ValidationError = require('../errors/validation_error.coffee')

module.exports = class RangeValidator
  constructor: (@min, @max) ->

  test: (value) =>
    if value < @min
      throw new ValidationError("needs to be bigger than #{_.json @min}", value, this)

    if value > @max
      throw new ValidationError("needs to be lower than #{_.json @max}", value, this)
