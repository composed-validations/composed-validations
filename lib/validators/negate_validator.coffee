ValidationError = require('../errors/validation_error.coffee')

DelegationalValidator = require('./delegational_validator.coffee')

module.exports = class NegateValidator extends DelegationalValidator
  test: (value) =>
    @runValidator value, (err) =>
      unless err
        # TODO: figure out a better way to handle child errors here
        childError = new ValidationError("", value, this)
        @throwError("validation negated failed", value, childError, this)

      value
