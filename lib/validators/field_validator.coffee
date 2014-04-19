_ = require('../util.coffee')
ValidationError = require("../error.coffee")

module.exports = class FieldValidator
  constructor: (@field, @validator, options = {}) ->
    @options = _.defaults options,
      optional: false

  async: -> @validator.async?() || false

  test: (object) =>
    if @options.optional && !_.has(object, @field)
      return

    unless object[@field]?
      throw new ValidationError("field #{@field} is not present on the object", object, this)

    value = object[@field]

    @runValidator value, (err) =>
      throw new ValidationError("", object, this) if err

  runValidator: (value, callback) =>
    try
      callback(null, @validator.test(value))
    catch err
      callback(err)