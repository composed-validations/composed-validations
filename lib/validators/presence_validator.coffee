_ = require('../util.coffee')
ValidationError = require('../error.coffee')

trim = (string) -> string.replace(/^\s+|\s+$/g, '')

module.exports = class PresenceValidator
  test: (value) =>
    unless @normalize(value)
      throw new ValidationError("#{value} is blank")

  normalize: (value) =>
    if _.isString(value)
      trim(value)
    else
      value