h = require('./helper.coffee')

DelegationalValidator = h.requireValidator('delegational')

describe "Delegational Validator", ->
  it "constructs and store the contained validator", (passValidator) ->
    validator = new DelegationalValidator(passValidator)

    expect(validator.validator).eq passValidator

  it "raises an error if you try to construct without a validator", ->
    createWith = (val) -> -> new DelegationalValidator(val)

    expect(createWith(null)).throw('null is not a valid validator')

  describe "#async", ->
    it "returns true if the contained validator is async", (asyncValidator) ->
      validator = new DelegationalValidator(asyncValidator)

      expect(validator.async()).true

    it "returns false when the contained validator is not async", (passValidator) ->
      validator = new DelegationalValidator(passValidator)

      expect(validator.async()).false

  describe "#runValidator", ->
    describe "sync operations", ->
      it "passes null to the callback when validation passes", (passValidator) ->
        validator = new DelegationalValidator(passValidator)

        validator.runValidator 'value', (err) ->
          expect(err).null

      it "passes the error to the callback when validation fails", (failValidator) ->
        validator = new DelegationalValidator(failValidator)

        validator.runValidator 'value', (err) ->
          expect(err.message).eq 'failed'

      it "only calls the callback once, even if the callback raises an error", (passValidator) ->
        validator = new DelegationalValidator(passValidator)
        callCount = 0
        callback = ->
          callCount += 1
          throw new Error('bad')

        try
          validator.runValidator 'value', callback
        catch err
          null

        expect(callCount).eq 1

    describe "async operations", ->
      it "passes null to the callback when validation resolves", (asyncValidator) ->
        validator = new DelegationalValidator(asyncValidator)

        validator.runValidator 'value', (err) ->
          expect(err).null

      it "passes the error to the callback when validation rejects", (asyncFailValidator) ->
        validator = new DelegationalValidator(asyncFailValidator)

        validator.runValidator 'value', (err) ->
          expect(err.message).eq 'failed'

  describe "#throwError", ->
    describe "when receive a ValidationError", ->
      it "creates a new ValidationError that wraps the child one", (failValidator) ->
        class SubValidationError extends h.ValidationError

        validator = new DelegationalValidator(failValidator)
        childError = new SubValidationError('message', 'input', failValidator)

        try
          validator.throwError('new message', 'newInput', childError)
        catch err
          expect(err).instanceof(h.ValidationError)
          expect(err.message).eq 'new message'
          expect(err.value).eq 'newInput'
          expect(err.validator).eq validator
          expect(err.childError).eq childError

      it "just throw error if the error is not a ValidationError", (passValidator) ->
        validator = new DelegationalValidator(passValidator)
        err = new Error('invalid')

        expect(-> validator.throwError('whatever', 'input', err)).throw(err)