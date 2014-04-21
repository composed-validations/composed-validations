h = require('./helper.coffee')

RangeValidator = h.requireValidator('range')

describe "RangeValidator", ->
  describe "#test", ->
    it "correctly validates if the value in on the defined range", ->
      h.testValidator new RangeValidator(-5, 32), (pass, fail) ->
        pass(-5)
        pass(32)
        pass(-3)
        pass(1)
        pass(0)
        pass(30)

        fail(-6, 'needs to be bigger than -5')
        fail(33, 'needs to be lower than 32')
        fail(-30, 'needs to be bigger than -5')
        fail(50, 'needs to be lower than 32')
