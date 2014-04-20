_ = require('../util.coffee')
ValidationError = require("../error.coffee")

DelegationalValidator = require('./delegational_validator.coffee')

module.exports = class FieldValidator extends DelegationalValidator
  constructor: (@field, validator, options = {}) ->
    super validator

    @options = _.defaults options,
      optional: false

  test: (object) =>
    if @options.optional && !_.has(object, @field)
      return

    unless object[@field]?
      throw new ValidationError("field #{@field} is not present on the object", object, this)

    value = object[@field]

    @runValidator value, (err) =>
      @throwError("Error on field #{@field}: #{err.message}", object, err, this) if err