h = require('./helper.coffee')

describe "RangeValidator", ->
  RangeValidator = h.requireValidator('range')

  describe "#test", ->
    it "correctly validates if the value in on the defined range", ->
      h.testValidator new RangeValidator(-5, 32), (pass, fail) ->
        pass(-5)
        pass(32)
        pass(-3)
        pass(1)
        pass(0)
        pass(30)

        fail(-6)
        fail(33)
        fail(-30)
        fail(50)