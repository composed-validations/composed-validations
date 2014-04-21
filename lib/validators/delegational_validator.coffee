_ = require('../util.coffee')
DelegatedValidationError = require('../errors/delegated_validation_error.coffee')

module.exports = class DelegationalValidator
  constructor: (@validator) -> _.guardValidator(@validator)

  async: -> @validator.async?() || false

  runValidator: (value, callback) =>
    if @async()
      @runValidatorAsync(value, callback)
    else
      @runValidatorSync(value, callback)

  runValidatorAsync: (value, callback) =>
    @validator.test(value).then(
      (res) => callback(null, res)
      (err) => callback(err)
    )

  runValidatorSync: (value, callback) =>
    res = null

    try
      res = @validator.test(value)
    catch err
      return callback(err)

    callback(null, res)

  throwError: (message, value, err) =>
    _.guardValidationError(err)

    throw new DelegatedValidationError(message, value, err, this)
