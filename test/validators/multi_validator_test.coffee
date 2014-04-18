h = require('./helper.coffee')

describe "MultiValidator", ->
  MultiValidator = h.requireValidator('multi')

  lazy "validator", -> new MultiValidator()

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