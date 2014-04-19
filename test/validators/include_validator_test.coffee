h = require('./helper.coffee')

IncludeValidator = h.requireValidator('include')

describe "IncludeValidator", ->
  describe "#test", ->
    it "passes when the value is included on the given list, fails otherwise", ->
      h.testValidator new IncludeValidator(['valid', 'stillValid']), (pass, fail) ->
        pass('valid')
        pass('stillValid')

        fail('invalid')
        fail(['valid'])
        fail({})