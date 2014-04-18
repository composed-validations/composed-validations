sinon = require('sinon')

ValidationError = require('../lib/error.coffee')

requireValidator = (name) -> require('../lib/' + name + '_validator.coffee')

testPass = (validator, value) ->
  message = "#{validator} should pass value #{JSON.stringify(value)}"

  expect((-> validator.test(value)), message).not.throw()

testPassAsync = (validator, value) ->
  message = "#{validator} should resolve value #{JSON.stringify(value)}"

  expect(validator.test(value), message).hold.not.reject()

testFail = (validator, value) ->
  message = "#{validator} should fail value #{JSON.stringify(value)}"

  expect((-> validator.test(value)), message).throw(ValidationError)

testFailAsync = (validator, value) ->
  message = "#{validator} should reject value #{JSON.stringify(value)}"

  expect(validator.test(value), message).hold.reject(ValidationError)

testValidator = (validator, builder) ->
  pass = (value) -> testPass(validator, value)
  fail = (value) -> testFail(validator, value)

  builder(pass, fail)

describe "Validators", ->
  lazy 'failValidator', -> test: -> throw new ValidationError('failed')
  lazy 'passValidator', -> test: sinon.stub()

  describe "PresenceValidator", ->
    PresenceValidator = requireValidator('presence')

    describe "#test", ->
      it "correctly validates the presence of a value", ->
        testValidator new PresenceValidator(), (pass, fail) ->
          pass('valid')
          pass(true)
          pass(['value'])
          pass({})
          pass([])

          fail(null)
          fail(undefined)
          fail(false)
          fail('  ')

  describe "RangeValidator", ->
    RangeValidator = requireValidator('range')

    describe "#test", ->
      it "correctly validates if the value in on the defined range", ->
        testValidator new RangeValidator(-5, 32), (pass, fail) ->
          pass(-5)
          pass(32)
          pass(-3)
          pass(1)
          pass(0)
          pass(30)

          fail(-6)
          fail(33)
          fail(-30)
          fail(50)

  describe "IncludeValidator", ->
    IncludeValidator = requireValidator('include')

    describe "#test", ->
      it "passes when the value is included on the given list, fails otherwise", ->
        testValidator new IncludeValidator(['valid', 'stillValid']), (pass, fail) ->
          pass('valid')
          pass('stillValid')

          fail('invalid')
          fail(['valid'])
          fail({})

  describe "FormatValidator", ->
    FormatValidator = requireValidator('format')

    describe "#test", ->
      it "passes when the value matches the given expression", ->
        testValidator new FormatValidator(/\d+/), (pass, fail) ->
          pass('123')
          pass('51')
          pass('a3c')

          fail('abc')
          fail(null)
          fail(undefined)
          fail(false)
          fail(true)

  describe "MultiValidator", ->
    MultiValidator = requireValidator('multi')

    lazy "validator", -> new MultiValidator()

    describe "#test", ->
      describe "empty validator", ->
        it "passes the test", (validator) ->
          testPass(validator, {})

      describe "given there is a failed validation", ->
        it "fails the test", (validator, failValidator) ->
          validator.add(failValidator)

          testFail(validator, {})

      describe "given there is a passing validation", ->
        it "passes the test", (validator, passValidator) ->
          validator.add(passValidator)

          testPass(validator, 'value')
          expect(passValidator.test.calledWith('value')).true

  describe "MultiAsyncValidator", ->
    MultiAsyncValidator = requireValidator('multi_async')

    lazy "validator", -> new MultiAsyncValidator()

    describe "#test", ->
      describe "empty validator", ->
        it "passes async", (validator) ->
          testPassAsync(validator, {})

      describe "given there is a failed validation", ->
        it "rejects with the validation error", (validator, failValidator) ->
          validator.add(failValidator)

          testFailAsync(validator, {})

      describe "given there is a passing validation", ->
        it "passes the test", (validator, passValidator) ->
          validator.add(passValidator)

          testPassAsync(validator, 'value')
          expect(passValidator.test.calledWith('value')).true

  describe "FieldValidator", ->
    FieldValidator = requireValidator('field')

    describe "#test", ->
      it "fails if the field is not present on the object", ->
        validator = new FieldValidator('name')

        testFail(validator, {})

      it "fails when the validation fails on the field", (failValidator) ->
        validator = new FieldValidator('name', failValidator)

        testFail(validator, {name: 'User'})

      it "passes when the validation passes", (passValidator) ->
        validator = new FieldValidator('name', passValidator)

        testPass(validator, {name: 'User'})
        expect(passValidator.test.calledWith('User')).true

      describe "given the optional flag is passed", ->
        lazy "validator", (failValidator) -> new FieldValidator('name', failValidator, optional: true)

        it "skips the validation and passes if the field is not present", (validator) ->
          testPass(validator, {})

        it "still runs the validation when the field is present", (validator) ->
          testFail(validator, {name: null})
          testFail(validator, {name: undefined})
          testFail(validator, {name: 'value'})