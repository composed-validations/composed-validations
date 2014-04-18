sinon = require('sinon')

ValidationError = require('../../lib/error.coffee')

lazy 'failValidator', -> test: -> throw new ValidationError('failed')
lazy 'passValidator', -> test: sinon.stub()
lazy 'asyncValidator', ->
  async: -> true
  test: ->

module.exports =
  requireValidator: (name) -> require('../../lib/validators/' + name + '_validator.coffee')

  testPass: (validator, value) ->
    message = "#{validator} should pass value #{JSON.stringify(value)}"

    expect((-> validator.test(value)), message).not.throw()

  testPassAsync: (validator, value) ->
    message = "#{validator} should resolve value #{JSON.stringify(value)}"

    expect(validator.test(value), message).hold.not.reject()

  testFail: (validator, value) ->
    message = "#{validator} should fail value #{JSON.stringify(value)}"

    expect((-> validator.test(value)), message).throw(ValidationError)

  testFailAsync: (validator, value) ->
    message = "#{validator} should reject value #{JSON.stringify(value)}"

    expect(validator.test(value), message).hold.reject(ValidationError)

  testValidator: (validator, builder) ->
    pass = (value) => @testPass(validator, value)
    fail = (value) => @testFail(validator, value)

    builder(pass, fail)