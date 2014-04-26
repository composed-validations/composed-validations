h = require('./helper.coffee')
sinon = require('sinon')

ValidationError = h.ValidationError
StructValidator = h.requireValidator('struct')

describe "Struct Validator", ->
  lazy "validator", -> new StructValidator()

  describe "#construct", ->
    it "correct initializes parent", ->
      validator = new StructValidator(async: true)

      expect(validator.async()).true

  describe "#validate", ->
    it "calls the addAssociated with the field and the validator wrapped", (validator, passValidator) ->
      validator._wrapFieldValidator = (field, v) -> ['wrapped', field, v]

      validator.addAssociated = sinon.spy()
      validator.validate('name', passValidator)

      expect(validator.addAssociated.calledWith('name', ['wrapped', 'name', passValidator])).true

    it "can add same validation on multiple fields", (validator, passValidator) ->
      validator._wrapFieldValidator = (field, v) -> ['wrapped', field, v]

      validator.addAssociated = sinon.spy()
      validator.validate('name', 'email', passValidator)

      expect(validator.addAssociated.args).eql [
        ['name', ['wrapped', 'name', passValidator]]
        ['email', ['wrapped', 'email', passValidator]]
      ]

    it "correctly wraps the error message if a string is given after the validator", (validator, failValidator) ->
      validator.validate('name', failValidator, "Name can't be blank")

      try
        validator.test({})
      catch err
        expect(err.errorMessages()).eql ["Name can't be blank"]

  describe "#addAssociated", ->
    it "calls the regular add with the validator", (validator, passValidator) ->
      validator.add = sinon.spy()
      validator.addAssociated('name', passValidator)

      expect(validator.add.calledWith(passValidator)).true

    it "calls to add the field validator", (validator, passValidator) ->
      validator.addFieldValidator = sinon.spy()
      validator.addAssociated('name', 'email', passValidator)

      expect(validator.addFieldValidator.args).eql [
        ['name', passValidator]
        ['email', passValidator]
      ]

  describe "#addFieldValidator", ->
    it "correctly initiates the sub validator with the given options", (passValidator) ->
      validator = new StructValidator(async: true)
      validator.addFieldValidator('name', passValidator)

      expect(validator.validatorForField('name').options).eql async: true

    it "adds the validator to field validator", (validator, passValidator, failValidator) ->
      validator.addFieldValidator('name', passValidator)

      expect(validator.fieldValidators['name'].validators).eql [passValidator]

      validator.addFieldValidator('name', failValidator)

      expect(validator.fieldValidators['name'].validators).eql [passValidator, failValidator]

    it "can add same validation to multiple fields at once", (validator, passValidator) ->
      validator.addFieldValidator('password', 'password_confirmation', passValidator)

      expect(validator.fieldValidators['password'].validators).eql [passValidator]
      expect(validator.fieldValidators['password_confirmation'].validators).eql [passValidator]

  describe "#test", ->
    it "when passes, it returns the input", (validator) ->
      h.testPass(validator, 'hello')

    describe "struct errors", ->
      it "contains the errors grouped by field and general errors", (validator, passValidator) ->
        fail1 = test: (value) -> throw new ValidationError("fail1", value, fail1)
        fail2 = test: (value) -> throw new ValidationError("fail2", value, fail2)
        fail3 = test: (value) -> throw new ValidationError("fail3", value, fail3)
        fail4 = test: (value) -> throw new ValidationError("fail3", value, fail4)

        validator.addAssociated('phone', passValidator)
        validator.addAssociated('name', 'email', fail1)
        validator.addAssociated('email', fail2)
        validator.addAssociated('name', 'address', fail3)
        validator.add(fail4)

        try
          validator.test({})
        catch err
          fetchMessage = (obj) -> obj.message

          expect(err.fieldErrors.phone).eql []
          expect(err.fieldErrors.name.map(fetchMessage), 'errors on name').eql ['fail1', 'fail3']
          expect(err.fieldErrors.email.map(fetchMessage), 'errors on email').eql ['fail1', 'fail2']
          expect(err.fieldErrors.address.map(fetchMessage), 'errors on address').eql ['fail3']
          expect(err.generalErrors.map(fetchMessage), 'errors on address').eql ['fail3']

  describe "#testField", ->
    it "runs only the validators associated with a given field", (validator) ->
      onFieldValidator = test: sinon.stub()
      onOtherFieldValidator = test: sinon.stub()
      onFieldByAssociationValidator = test: sinon.stub()

      validator.validate('name', onFieldValidator)
      validator.validate('other', onOtherFieldValidator)
      validator.addAssociated('name', onFieldByAssociationValidator)

      validator.testField('name', name: 'value')

      expect(onFieldValidator.test.calledWith('value'), 'on field must be called').true
      expect(onOtherFieldValidator.test.calledWith('value'), 'on other field must not be called').false
      expect(onFieldByAssociationValidator.test.calledWith(name: 'value'), 'associated must be called').true

    it "is able to run fields into nested structures", (validator) ->
      notCall = sinon.stub()
      call = sinon.stub()

      substruct = new StructValidator()
      substruct.validate('name', test: call)
      substruct.validate('other', test: notCall)

      validator.validate('subfield', test: notCall)
      validator.validate('subfield', new StructValidator().validate('other', test: notCall))
      validator.validate('subfield', substruct)
      validator.validate('subfield', new StructValidator().validate('name', test: notCall))
      validator.validate('extra', test: notCall)

      validator.testField('subfield.name', {subfield: {name: "ok", other: "value"}})

      expect(call.calledWith("ok")).true
      expect(notCall.called).false

    it "throws correct errors for field lookup problems", (validator) ->
      addressValidator = new StructValidator()
      addressValidator.validate('street', 'city', test: ->)

      validator.validate('address', addressValidator)

      expect(-> validator.testField('name')).throw('There are no validators associated with the field "name"')
      expect(-> validator.testField('address.number')).throw('There are no validators associated with the field "address.number"')

    it "throws correct errors for value lookup problems", (validator) ->
      addressValidator = new StructValidator()
      addressValidator.validate('street', 'city', test: ->)

      validator.validate('address', addressValidator)

      expect(-> validator.testField('address.street', {})).throw('{} doesn\'t have the property "address"')
      expect(-> validator.testField('address.street', {address: {}})).throw('{} doesn\'t have the property "street"')

  describe "validatorForField", ->
    it "throws an error when the field has no associated validations", (validator) ->
      expect(-> validator.validatorForField('name', 'value')).throw('There are no validators associated with the field "name"')
