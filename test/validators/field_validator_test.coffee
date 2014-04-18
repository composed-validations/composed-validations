h = require('./helper.coffee')

describe "FieldValidator", ->
  FieldValidator = h.requireValidator('field')

  describe "#test", ->
    it "fails if the field is not present on the object", ->
      validator = new FieldValidator('name')

      h.testFail(validator, {})

    it "fails when the validation fails on the field", (failValidator) ->
      validator = new FieldValidator('name', failValidator)

      h.testFail(validator, {name: 'User'})

    it "passes when the validation passes", (passValidator) ->
      validator = new FieldValidator('name', passValidator)

      h.testPass(validator, {name: 'User'})
      expect(passValidator.test.calledWith('User')).true

    describe "given the optional flag is passed", ->
      lazy "validator", (failValidator) -> new FieldValidator('name', failValidator, optional: true)

      it "skips the validation and passes if the field is not present", (validator) ->
        h.testPass(validator, {})

      it "still runs the validation when the field is present", (validator) ->
        h.testFail(validator, {name: null})
        h.testFail(validator, {name: undefined})
        h.testFail(validator, {name: 'value'})