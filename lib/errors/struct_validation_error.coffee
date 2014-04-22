MultiValidationError = require('./multi_validation_error.coffee')

module.exports = class StructValidationError extends MultiValidationError
  constructor: ->
    super

    @indexFieldErros()

  indexFieldErros: =>
    @generalErrors = []
    @fieldErrors = {}

    for err in @errors
      assigned = false

      for field, multiVal of @validator.fieldValidators
        if multiVal.validators.indexOf(err.validator) > -1
          @fieldErrors[field] ||= []
          @fieldErrors[field].push(err)
          assigned = true

      @generalErrors.push(err) unless assigned

    this
