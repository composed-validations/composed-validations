module.exports =
  Promise: require('promise')

  _: require('./util.coffee')

  DelegatedValidationError: require('./errors/delegated_validation_error.coffee')
  MultiValidationError:     require('./errors/multi_validation_error.coffee')
  ValidationError:          require('./errors/validation_error.coffee')

validators = [
  'all', 'delegational', 'field', 'format', 'include', 'multi', 'negate', 'presence'
  'range', 'rephrase', 'sequence', 'struct'
]

wrapConstruct = (klass) -> (args...) -> new klass(args...)

for validator in validators
  klass = require('./validators/' + validator + '_validator.coffee')
  wrapped = wrapConstruct(klass)
  wrapped.klass = klass

  module.exports[validator] = wrapped

module.exports.error = wrapConstruct(module.exports.ValidationError)
