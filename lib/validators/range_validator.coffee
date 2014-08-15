_ = require('../util.coffee')
ValidationError = require('../errors/validation_error.coffee')

module.exports = class RangeValidator
  constructor: (@min, @max) ->
    throw new Error("Range Validator: input min (#{@min}) is greater than the max (#{@max})") if @min > @max

  test: (value) =>
    if value < @min
      throw new ValidationError("needs to be greater than #{_.json @min}", value, this)

    if value > @max
      throw new ValidationError("needs to be less than #{_.json @max}", value, this)

    value
