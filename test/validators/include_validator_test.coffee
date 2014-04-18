h = require('./helper.coffee')

describe "IncludeValidator", ->
  IncludeValidator = h.requireValidator('include')

  describe "#test", ->
    it "passes when the value is included on the given list, fails otherwise", ->
      h.testValidator new IncludeValidator(['valid', 'stillValid']), (pass, fail) ->
        pass('valid')
        pass('stillValid')

        fail('invalid')
        fail(['valid'])
        fail({})