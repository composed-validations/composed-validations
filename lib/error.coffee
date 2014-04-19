module.exports = class ValidationError extends Error
  constructor: (@message, @value, @validator) ->