window.ComposedValidations =
  Promise: require('promise')

  ValidationError:     require('./error.coffee')
  FieldValidator:      require('./field_validator.coffee')
  IncludeValidator:    require('./include_validator.coffee')
  MultiValidator:      require('./multi_validator.coffee')
  MultiAsyncValidator: require('./multi_async_validator.coffee')
  PresenceValidator:   require('./presence_validator.coffee')
  RangeValidator:      require('./range_validator.coffee')