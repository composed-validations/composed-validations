h = require('./helper.coffee')

AllValidator = h.requireValidator('all')

describe "All Validator", ->
  lazy "evenValidator", ->
    test: (number) ->
      unless (number % 2) == 0
        throw new h.ValidationError("#{number} is not even", number, this)

  describe "#test", ->
    it "fails if the given value is not a list", (passValidator) ->
      validator = new AllValidator(passValidator)

      h.testValidator validator, (pass, fail) ->
        fail({}, '{} is not a list')
        fail(false, "false is not a list")
        fail(true, "true is not a list")
        fail(undefined, "undefined is not a list")

        pass([])
        pass('')

    it "testing against data", ->
      evenValidator =
        test: (number) ->
          unless (number % 2) == 0
            throw new h.ValidationError("#{number} is not even", number, this)

      validator = new AllValidator(evenValidator)

      h.testValidator validator, (pass, fail) ->
        pass([])
        pass([2])
        pass([0, 2, 6, 8])

        fail([1])
        fail([1, 2, 3])
        fail([2, 4, 6, 7, 8])

    it "works testing with async validators", (evenValidator) ->
      asyncEvenValidator = test: h._.lift(evenValidator.test), async: -> true

      validator = new AllValidator(asyncEvenValidator)

      h.testAsyncValidator validator, (pass, fail) ->
        pass([])
        pass([2])
        pass([0, 2, 6, 8])

        fail([1])
        fail([1, 2, 3])
        fail([2, 4, 6, 7, 8])