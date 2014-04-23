_ = require('../util.coffee')
ValidationError = require("../errors/validation_error.coffee")

DelegationalValidator = require('./delegational_validator.coffee')

module.exports = class FieldValidator extends DelegationalValidator
  constructor: (@field, validator, options = {}) ->
    super validator

    @options = _.defaults options,
      optional: false

  test: (object) =>
    unless object
      throw new ValidationError("Can't access field #{_.json @field} on #{_.json object}", object, this)

    unless _.has(object, @field)
      return object if @options.optional
      throw new ValidationError("Field #{@field} is not present on the object #{_.json object}", object, this)

    value = object[@field]

    @runValidator value, (err) =>
      @throwError("#{_.humanizeFieldName @field} #{err.message}", object, err, this) if err

      object
