module.exports = class DelegationalValidator
  constructor: (@validator) ->

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