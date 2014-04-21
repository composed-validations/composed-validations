DelegationalValidator = require('./delegational_validator.coffee')

module.exports = class RephraseValidator extends DelegationalValidator
  constructor: (@message, validator) ->
    super(validator)

  test: (value) =>
    @runValidator value, (err) =>
      if err
        err.message = @message

        throw err
