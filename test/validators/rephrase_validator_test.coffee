h = require('./helper.coffee')

RephraseValidator = h.requireValidator('rephrase')

describe "Rephrase Validator", ->
  it "changes the validation error message and raises it again", (failValidator) ->
    validator = new RephraseValidator('new error message', failValidator)

    try
      validator.test({})
    catch err
      expect(err).eq failValidator.err
      expect(err.message).eq 'new error message'

  it "passes when the contained validation passes", (passValidator) ->
    validator = new RephraseValidator('', passValidator)

    h.testPass(validator, {})
