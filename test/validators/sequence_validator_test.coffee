h = require('./helper.coffee')
sinon = require('sinon')

SequenceValidator = h.requireValidator('sequence')

describe "Sequence Validator", ->
  it "doent error for empty list", ->
    validator = new SequenceValidator()

    h.testPass(validator, {})

  describe "sync scenario", ->
    it "fails with the same error as the internal validator", (passValidator, failValidator) ->
      stub = sinon.stub()
      validator = new SequenceValidator()

      validator.add(passValidator)
      validator.add(failValidator)
      validator.add(test: stub)

      try
        validator.test({})
      catch err
        expect(err).eq failValidator.err

    it "must pass the returned value to the next validator", ->
      stub = sinon.stub()
      increaseValidator = test: (value) -> value + 1

      validator = new SequenceValidator()

      validator.add(increaseValidator)
      validator.add(increaseValidator)
      validator.add(test: stub)

      validator.test(2)

      expect(stub.args[0][0]).eq(4)

  describe "async scenario", ->
    it "running async validations", (passValidator, failValidator) ->
      stub = sinon.stub()
      validator = new SequenceValidator(async: true)

      validator.add(passValidator)
      validator.add(failValidator)
      validator.add(test: stub)

      validator.test({}).then(
        -> throw new Error("should not reach here")
        (err) ->
          expect(err).eq failValidator.err
          expect(stub.called).false
      )

    it "must pass the returned value to the next validator", ->
      stub = sinon.stub()
      increaseValidator = test: (value) -> value + 1

      validator = new SequenceValidator(async: true)

      validator.add(increaseValidator)
      validator.add(increaseValidator)
      validator.add(test: stub)

      validator.test(2).then -> expect(stub.args[0][0]).eq(4)
