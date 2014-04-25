Promise = require('promise')

ValidationError = require('./errors/validation_error.coffee')

module.exports =
  json: (obj) -> JSON.stringify(obj)

  defaults: (object, defaults) ->
    for key, value of object
      defaults[key] = value

    defaults

  isString: (value) ->
    typeof value == 'string' ||
      value && typeof value == 'object' && toString.call(value) == '[object String]' || false;

  isFunction: (value) -> typeof value == 'function'

  isValidator: (value) -> @isFunction(value?.test)

  isValidationError: (value) -> value instanceof ValidationError

  isArray: (value) ->
    (value && typeof value == 'object' && typeof value.length == 'number' &&
      toString.call(value) == '[object Array]') || false

  guardValidator: (validator) ->
    unless @isValidator(validator)
      throw new TypeError("#{@json validator} is not a valid validator")

  guardValidationError: (err) -> throw err unless @isValidationError(err)

  contains: (list, value) ->
    for obj in list
      return true if obj == value

    false

  map: (list, iterator) ->
    newList = []

    for value in list
      newList.push(iterator(value))

    newList

  reduce: (list, initial, iterator) ->
    for item in list
      initial = iterator(initial, item)

    initial

  lift: (fn) ->
    (args...) ->
      try
        Promise.resolve(fn(args...))
      catch err
        Promise.reject(err)

  humanizeFieldName: (field) ->
    if field.length > 0
      field = field.replace(/_/g, ' ')
      field = field.charAt(0).toUpperCase() + field.substr(1).toLowerCase()

    field
