h = require('./helper.coffee')

PresenceValidator = h.requireValidator('presence')

describe "PresenceValidator", ->
  describe "#test", ->
    it "correctly validates the presence of a value", ->
      h.testValidator new PresenceValidator(), (pass, fail) ->
        pass('valid')
        pass(true)
        pass(['value'])
        pass({})
        pass([])

        fail(null, "null is blank")
        fail(undefined, "undefined is blank")
        fail(false, "false is blank")
        fail('  ', '"  " is blank')