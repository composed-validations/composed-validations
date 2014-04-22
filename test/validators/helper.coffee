# just a safe check to ensure the index is loading without errors
require('../../index')

Promise = require('promise')
sinon = require('sinon')

ValidationError = require('../../lib/errors/validation_error.coffee')

lazy 'passValidator', -> test: sinon.stub()
lazy 'failValidator', ->
  error = new ValidationError('failed', null, null)

  validator =
    test: (value) ->
      error.value = value
      throw error

    err: error

  error.validator = validator

  validator

lazy 'errorValidator', -> test: (value) -> throw new Error('error')
lazy 'asyncValidator', ->
  async: -> true
  test: sinon.stub().returns(Promise.resolve(null))
lazy 'asyncFailValidator', ->
  async: -> true
  test: (value) -> Promise.reject(new ValidationError('failed', value, this))

extractClassName = (object) -> object.constructor.name

module.exports =
  _: require('../../lib/util.coffee')

  ValidationError: ValidationError

  requireLib: (lib) -> require('../../lib/' + lib)
  requireValidator: (name) -> @requireLib("validators/#{name}_validator.coffee")

  testPass: (validator, value) ->
    message = "#{extractClassName validator} should pass value #{JSON.stringify(value)}"

    expect((-> validator.test(value)), message).not.throw()

  testPassAsync: (validator, value) ->
    message = "#{extractClassName validator} should resolve value #{JSON.stringify(value)}"

    expect(validator.test(value), message).hold.not.reject()

  testFail: (validator, value, message) ->
    errorMessage = "#{extractClassName validator} should fail value #{JSON.stringify(value)}"

    try
      validator.test(value)
    catch err
      expect(err).instanceof(ValidationError)
      expect(err.validator).eq(validator)
      expect(err.value).eq(value)
      expect(err.message).eq(message) if message

      return

    throw new Error(errorMessage)

  testFailAsync: (validator, value) ->
    message = "#{extractClassName validator} should reject value #{JSON.stringify(value)}"

    expect(validator.test(value), message).hold.reject(ValidationError)

  testValidator: (validator, builder) ->
    pass = (value) => @testPass(validator, value)
    fail = (value, message) => @testFail(validator, value, message)

    builder(pass, fail)

  testAsyncValidator: (validator, builder) ->
    pass = (value) => @testPassAsync(validator, value)
    fail = (value, message) => @testFailAsync(validator, value, message)

    builder(pass, fail)
