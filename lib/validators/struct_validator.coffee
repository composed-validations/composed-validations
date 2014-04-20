_ = require('../util.coffee')
MultiValidator = require('./multi_validator.coffee')
FieldValidator = require('./field_validator.coffee')

module.exports = class StructValidator extends MultiValidator
  constructor: ->
    super

    @fieldValidators = {}

  addField: (field, validator) =>
    wrapped = @_wrapFieldValidator(field, validator)

    @addAssociated(field, wrapped)

  addAssociated: (field, validator) =>
    @add(validator)

    @addFieldValidator(field, validator)

  addFieldValidator: (fields, validator) =>
    fields = [fields] unless _.isArray(fields)

    for field in fields
      @fieldValidators[field] ||= new MultiValidator()
      @fieldValidators[field].add(validator)

    this

  testField: (field, value) => @validatorForField(field).test(value)

  validatorForField: (field) =>
    unless validators = @fieldValidators[field]
      throw new Error("There are no validators associated with the field #{_.json field}")

    validators

  _wrapFieldValidator: (field, validator) => new FieldValidator(field, validator)
