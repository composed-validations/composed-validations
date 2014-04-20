h = require('./helper.coffee')
sinon = require('sinon')

StructValidator = h.requireValidator('struct')

describe "Struct Validator", ->
  lazy "validator", -> new StructValidator()

  describe "#construct", ->
    it "correct initializes parent", ->
      validator = new StructValidator(async: true)

      expect(validator.async()).true

  describe "#addField", ->
    it "calls the addAssociated with the field and the validator wrapped", (validator, passValidator) ->
      validator._wrapFieldValidator = (field, v) -> ['wrapped', field, v]

      validator.addAssociated = sinon.spy()
      validator.addField('name', passValidator)

      expect(validator.addAssociated.calledWith('name', ['wrapped', 'name', passValidator])).true

  describe "#addAssociated", ->
    it "calls the regular add with the validator", (validator, passValidator) ->
      validator.add = sinon.spy()
      validator.addAssociated('name', passValidator)

      expect(validator.add.calledWith(passValidator)).true

    it "calls to add the field validator", (validator, passValidator) ->
      validator.addFieldValidator = sinon.spy()
      validator.addAssociated('name', passValidator)

      expect(validator.addFieldValidator.calledWith('name', passValidator)).true

  describe "#addFieldValidator", ->
    it "adds the validator to field validator", (validator, passValidator, failValidator) ->
      validator.addFieldValidator('name', passValidator)

      expect(validator.fieldValidators['name'].validators).eql [passValidator]

      validator.addFieldValidator('name', failValidator)

      expect(validator.fieldValidators['name'].validators).eql [passValidator, failValidator]

    it "can add same validation to multiple fields at once", (validator, passValidator) ->
      validator.addFieldValidator(['password', 'password_confirmation'], passValidator)

      expect(validator.fieldValidators['password'].validators).eql [passValidator]
      expect(validator.fieldValidators['password_confirmation'].validators).eql [passValidator]

  describe "#test", ->

  describe "#testField", ->
    it "runs only the validators associated with a given field", (validator) ->
      onFieldValidator = test: sinon.stub()
      onOtherFieldValidator = test: sinon.stub()
      onFieldByAssociationValidator = test: sinon.stub()

      validator.addField('name', onFieldValidator)
      validator.addField('other', onOtherFieldValidator)
      validator.addAssociated('name', onFieldByAssociationValidator)

      validator.testField('name', name: 'value')

      expect(onFieldValidator.test.calledWith('value'), 'on field must be called').true
      expect(onOtherFieldValidator.test.calledWith('value'), 'on other field must not be called').false
      expect(onFieldByAssociationValidator.test.calledWith(name: 'value'), 'associated must be called').true

  describe "validatorForField", ->
    it "throws an error when the field has no associated validations", (validator) ->
      expect(-> validator.validatorForField('name', 'value')).throw('There are no validators associated with the field "name"')
