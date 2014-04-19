h = require('./helper.coffee')

NegateValidator = h.requireValidator('negate')

describe "Negate Validator", ->
  describe "#async", ->
    it "returns true if the contained validator is async", (asyncValidator) ->
      validator = new NegateValidator(asyncValidator)

      expect(validator.async()).true

    it "returns false when the contained validator is not async", (passValidator) ->
      validator = new NegateValidator(passValidator)

      expect(validator.async()).false

  describe "#test", ->
    describe "when the validation is sync", ->
      it "fails when the validation passes", (passValidator) ->
        validator = new NegateValidator(passValidator)

        h.testFail(validator, 'input')
        expect(passValidator.test.calledWith('input')).true

      it "passes when the validator fails", (failValidator) ->
        validator = new NegateValidator(failValidator)

        h.testPass(validator, {})

    describe "when the validation is async", ->
      it "rejects when the validation resolves", (asyncValidator) ->
        validator = new NegateValidator(asyncValidator)

        h.testFailAsync(validator, 'input')
        expect(asyncValidator.test.calledWith('input')).true

      it "resolves when the validator rejects", (asyncFailValidator) ->
        validator = new NegateValidator(asyncFailValidator)

        h.testPassAsync(validator, {})