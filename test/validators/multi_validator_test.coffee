h = require('./helper.coffee')

MultiValidator = h.requireValidator('multi')

describe "MultiValidator", ->
  lazy "validator", -> new MultiValidator()

  describe "#constructor", ->
    it "initialize with empty validators list when nothing is given", ->
      validator = new MultiValidator()

      expect(validator.validators).eql []

    it "can initialize with a list of validators", (passValidator) ->
      validator = new MultiValidator([passValidator])

      expect(validator.validators).eql [passValidator]

  describe "#add", ->
    it "throws an error if you trying to add a non validator", (validator) ->
      expect(-> validator.add(null)).throw('null is not a valid validator')

    it "throws an error when you try to add an async validator", (validator, asyncValidator) ->
      expect(-> validator.add(asyncValidator)).throw("Can't add async validators into the MultiValidator, use the MultiAsyncValidator instead.")

    it "doesn't throw an error when you add an async validator to an async MultiValidator", (validator, asyncValidator) ->
      validator.async = -> true

      expect(-> validator.add(asyncValidator)).not.throw()

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