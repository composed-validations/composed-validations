MultiValidationError = require('./multi_validation_error.coffee')

module.exports = class StructValidationError extends MultiValidationError
  constructor: ->
    super

    @indexFieldErros()

  indexFieldErros: =>
    @fieldErrors = {}

    for err in @errors
      for field, multiVal of @validator.fieldValidators
        if multiVal.validators.indexOf(err.validator) > -1
          @fieldErrors[field] ||= []
          @fieldErrors[field].push(err)
