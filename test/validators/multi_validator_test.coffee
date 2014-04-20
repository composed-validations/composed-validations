h = require('./helper.coffee')

MultiValidator = h.requireValidator('multi')

describe "MultiValidator", ->
  lazy "validator", -> new MultiValidator()

  describe "#constructor", ->
    it "initialize with empty validators list when nothing is given", ->
      validator = new MultiValidator()

      expect(validator.validators).eql []

    it "can initialize with async option", ->
      validator = new MultiValidator(async: true)

      expect(validator.async()).true

  describe "#add", ->
    it "throws an error if you trying to add a non validator", (validator) ->
      expect(-> validator.add(null)).throw('null is not a valid validator')

    it "throws an error when you try to add an async validator", (validator, asyncValidator) ->
      expect(-> validator.add(asyncValidator)).throw("Can't add async validators into a sync MultiValitor, use the {sync: true} option to allow async validators to be added.")

    it "doesn't throw an error when you add an async validator to an async MultiValidator", (validator, asyncValidator) ->
      validator.async = -> true

      expect(-> validator.add(asyncValidator)).not.throw()

  describe "#test", ->
    describe "sync validations", ->
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

    describe "async validations", ->
      lazy "validator", -> new MultiValidator(async: true)

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

      describe "given there is an async failed validation", ->
        it "rejects with the validation error", (validator, asyncFailValidator) ->
          validator.add(asyncFailValidator)

          h.testFailAsync(validator, {})

      describe "given there is a passing async validation", ->
        it "passes the test", (validator, asyncValidator) ->
          validator.add(asyncValidator)

          h.testPassAsync(validator, 'value')
          expect(asyncValidator.test.calledWith('value')).true