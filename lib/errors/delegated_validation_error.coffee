ValidationError = require('../errors/validation_error.coffee')

module.exports = class DelegatedValidationError extends ValidationError
  constructor: (message, value, @childError, validator) ->
    super(message, value, validator)
