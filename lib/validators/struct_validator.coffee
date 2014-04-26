_ = require('../util.coffee')
MultiValidator = require('./multi_validator.coffee')
FieldValidator = require('./field_validator.coffee')
RephraseValidator = require('./rephrase_validator.coffee')

StructValidationError = require('../errors/struct_validation_error.coffee')

module.exports = class StructValidator extends MultiValidator
  constructor: ->
    super

    @fieldValidators = {}

  validate: (fields..., validator) =>
    if arguments.length > 2 and _.isString(validator)
      errorMessage = validator
      validator = fields.pop()

    for field in fields
      wrapped = @_wrapFieldValidator(field, validator)
      wrapped = @_wrapErrorMessage(errorMessage, wrapped) if errorMessage

      @addAssociated(field, wrapped)

    this

  test: (value) =>
    @multiTest value, (errors) =>
      throw new StructValidationError(null, value, this, errors) if errors.length > 0

      value

  addAssociated: (fields..., validator) =>
    @add(validator)

    for field in fields
      @addFieldValidator(field, validator)

    this

  addFieldValidator: (fields..., validator) =>
    _.guardValidator(validator)

    for field in fields
      @fieldValidators[field] ||= new MultiValidator(@options)
      @fieldValidators[field].add(validator)

    this

  testField: (field, value) =>
    validator = @validatorForField(field)
    value = @valueForField(field, value)

    validator.test(value)

  validatorForField: (field) =>
    unless validator = @lookupForField(field)
      throw new Error("There are no validators associated with the field #{_.json field}")

    validator

  lookupForField: (field, context = @fieldValidators) =>
    [head, tail...] = field.split('.')

    if tail.length > 0
      for validator in context[head].validators
        subStruct = validator.validator.fieldValidators

        if subStruct
          context = subStruct

          continue unless context[tail[0]]

          break

      @lookupForField(tail.join('.'), context)
    else
      context[head]

  valueForField: (field, value) =>
    [head, tail...] = field.split('.')

    unless value.hasOwnProperty(head)
      throw new Error("#{_.json value} doesn't have the property #{_.json head}")

    if tail.length > 0
      @valueForField(tail.join('.'), value[head])
    else
      value

  _wrapFieldValidator: (field, validator) => new FieldValidator(field, validator)
  _wrapErrorMessage: (message, validator) => new RephraseValidator(message, validator)
