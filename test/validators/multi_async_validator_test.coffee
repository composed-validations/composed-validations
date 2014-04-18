h = require('./helper.coffee')

describe "MultiAsyncValidator", ->
  MultiAsyncValidator = h.requireValidator('multi_async')

  lazy "validator", -> new MultiAsyncValidator()

  describe "#test", ->
    describe "empty validator", ->
      it "passes async", (validator) ->
        h.testPassAsync(validator, {})

    describe "given there is a failed validation", ->
      it "rejects with the validation error", (validator, failValidator) ->
        validator.add(failValidator)

        h.testFailAsync(validator, {})

    describe "given there is a passing validation", ->
      it "passes the test", (validator, passValidator) ->
        validator.add(passValidator)

        h.testPassAsync(validator, 'value')
        expect(passValidator.test.calledWith('value')).true