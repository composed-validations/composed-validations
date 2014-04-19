ValidationError = require('../error.coffee')

DelegationalValidator = require('./delegational_validator.coffee')

module.exports = class NegateValidator extends DelegationalValidator
  test: (value) =>
    @runValidator value, (err) =>
      throw new ValidationError("validation negated failed", value, this) unless err