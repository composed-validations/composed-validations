_ = require('../util.coffee')
ValidationError = require('../errors/validation_error.coffee')

trim = (string) -> string.replace(/^\s+|\s+$/g, '')

module.exports = class PresenceValidator
  test: (value) =>
    unless @normalize(value)
      throw new ValidationError("can't be blank", value, this)

    value

  normalize: (value) =>
    if _.isString(value)
      trim(value)
    else
      value
