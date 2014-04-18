h = require('./helper.coffee')

describe "FormatValidator", ->
  FormatValidator = h.requireValidator('format')

  describe "#test", ->
    it "passes when the value matches the given expression", ->
      h.testValidator new FormatValidator(/\d+/), (pass, fail) ->
        pass('123')
        pass('51')
        pass('a3c')

        fail('abc')
        fail(null)
        fail(undefined)
        fail(false)
        fail(true)