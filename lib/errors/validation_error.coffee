module.exports = class ValidationError extends Error
  constructor: (@message, @value, @validator) ->
    Error.call(this)
    Error.captureStackTrace(this, this.constructor) if Error.captureStackTrace

    @name = this.constructor.name
