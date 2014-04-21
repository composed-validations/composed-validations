h = require('./helper.coffee')

FieldValidator = h.requireValidator('field')

describe "FieldValidator", ->
  describe "#test", ->
    it "fails if the field is falsy", (passValidator) ->
      validator = new FieldValidator('name', passValidator)

      h.testFail(validator, null, "Can't access field \"name\" on null")
      h.testFail(validator, false, "Can't access field \"name\" on false")
      h.testFail(validator, undefined, "Can't access field \"name\" on undefined")

    it "fails if the field is not present on the object", (passValidator) ->
      validator = new FieldValidator('name', passValidator)

      h.testValidator validator, (pass, fail) ->
        fail({}, 'Field name is not present on the object {}')
        pass(name: null, 'Field name is not present on the object {}')
        pass(name: undefined, 'Field name is not present on the object {}')
        pass(name: false, 'Field name is not present on the object {}')

    it "fails when the validation fails on the field", (failValidator) ->
      validator = new FieldValidator('name', failValidator)

      h.testFail(validator, {name: 'User'}, 'Name failed')

    it "passes when the validation passes", (passValidator) ->
      validator = new FieldValidator('name', passValidator)

      h.testPass(validator, {name: 'User'})
      expect(passValidator.test.calledWith('User')).true

    describe "given the optional flag is passed", ->
      lazy "validator", (failValidator) -> new FieldValidator('name', failValidator, optional: true)

      it "skips the validation and passes if the field is not present", (validator) ->
        h.testPass(validator, {})

      it "still runs the validation when the field is present", (validator) ->
        h.testValidator validator, (pass, fail) ->
          fail({name: null})
          fail({name: undefined})
          fail({name: 'value'})
