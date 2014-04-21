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

        fail(null, "can't be blank")
        fail(undefined, "can't be blank")
        fail(false, "can't be blank")
        fail('  ', "can't be blank")
