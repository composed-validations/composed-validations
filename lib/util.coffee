Promise = require('promise')

module.exports =
  defaults: (object, defaults) ->
    for key, value of object
      defaults[key] = value

    defaults

  isString: (value) ->
    typeof value == 'string' ||
      value && typeof value == 'object' && toString.call(value) == '[object String]' || false;

  isFunction: (value) -> typeof value == 'function'

  isValidator: (value) -> @isFunction(value?.test)

  contains: (list, value) ->
    for obj in list
      return true if obj == value

    false

  map: (list, iterator) ->
    newList = []

    for value in list
      newList.push(iterator(value))

    newList

  has: (object, lookupKey) ->
    for key, value of object
      return true if key == lookupKey

    false

  lift: (fn) ->
    (args...) ->
      try
        Promise.resolve(fn(args...))
      catch err
        Promise.reject(err)