h = require('./helper.coffee')

MultiValidator = h.requireValidator('multi')

describe "MultiValidator", ->
  lazy "validator", -> new MultiValidator()

  describe "#add", ->
    it "throws an error when you try to add an async validator", (validator, asyncValidator) ->
      expect(-> validator.add(asyncValidator)).throw("Can't add async validators into the MultiValidator, use the MultiAsyncValidator instead.")

  describe "#test", ->
    describe "empty validator", ->
      it "passes the test", (validator) ->
        h.testPass(validator, {})

    describe "given there is a failed validation", ->
      it "fails the test", (validator, failValidator) ->
        validator.add(failValidator)

        h.testFail(validator, {})

    describe "given there is a passing validation", ->
      it "passes the test", (validator, passValidator) ->
        validator.add(passValidator)

        h.testPass(validator, 'value')
        expect(passValidator.test.calledWith('value')).true