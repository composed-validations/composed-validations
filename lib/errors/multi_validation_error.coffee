_ = require('../util.coffee')
ValidationError = require('./validation_error.coffee')

module.exports = class MultiValidationError extends ValidationError
  constructor: (message, value, validator, @errors) ->
    super(message + "\n" + @errorMessages().join("\n"), value, validator)

  errorMessages: =>
    _.map(@errors, (err) =>
      err.message
    )
