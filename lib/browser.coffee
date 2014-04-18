window.ComposedValidations =
  Promise: require('promise')

  ValidationError:     require('./error.coffee')
  FieldValidator:      require('./validators/field_validator.coffee')
  IncludeValidator:    require('./validators/include_validator.coffee')
  MultiValidator:      require('./validators/multi_validator.coffee')
  MultiAsyncValidator: require('./validators/multi_async_validator.coffee')
  PresenceValidator:   require('./validators/presence_validator.coffee')
  RangeValidator:      require('./validators/range_validator.coffee')