h = require('./helper.coffee')
sinon = require('sinon')
Promise = require('promise')

MultiValidator = h.requireValidator('multi')

describe "MultiValidator", ->
  lazy "validator", -> new MultiValidator()

  describe "#constructor", ->
    it "initialize with empty validators list when nothing is given", ->
      validator = new MultiValidator()

      expect(validator.validators).eql []

    it "can initialize with async option", ->
      validator = new MultiValidator(async: true)

      expect(validator.async()).true

  describe "#add", ->
    it "throws an error if you trying to add a non validator", (validator) ->
      expect(-> validator.add(null)).throw('null is not a valid validator')

    it "throws an error when you try to add an async validator", (validator, asyncValidator) ->
      expect(-> validator.add(asyncValidator)).throw("Can't add async validators into a sync MultiValitor, use the {sync: true} option to allow async validators to be added.")

    it "doesn't throw an error when you add an async validator to an async MultiValidator", (validator, asyncValidator) ->
      validator.async = -> true

      expect(-> validator.add(asyncValidator)).not.throw()

  describe "#testSync", ->
    it "returns a blank list when there are no errors", (validator) ->
      expect(validator.testSync()).eql []

    it "collects errors from all failed validators", (validator, passValidator, failValidator) ->
      validator.add(failValidator)
      validator.add(passValidator)
      validator.add(failValidator)

      expect(validator.testSync()).length(2)

    it "must call the validator with the correct params", (validator, passValidator) ->
      validator.add(passValidator)

      validator.testSync('value')

      expect(passValidator.test.calledWith('value')).true

    it "in case a non validation error is raised, it must be raised", (validator, passValidator, failValidator, errorValidator) ->
      validator.add(failValidator)
      validator.add(passValidator)
      validator.add(errorValidator)

      expect(-> validator.testSync()).throw('error')

  describe "#testAsync", ->
    lazy 'validator', -> new MultiValidator(async: true)

    it "returns a blank list when there are no errors", (validator) ->
      validator.testAsync().then (errors) ->
        expect(errors).eql []

    describe "working with async validations", ->
      it "collects errors from all failed validators", (validator, asyncValidator, asyncFailValidator) ->
        validator.add(asyncFailValidator)
        validator.add(asyncValidator)
        validator.add(asyncFailValidator)

        validator.testAsync().then (errors) ->
          expect(errors).length(2)

      it "must call the validator with the correct params", (validator, asyncValidator) ->
        validator.add(asyncValidator)

        validator.testAsync('value').then ->
          expect(asyncValidator.test.calledWith('value')).true

      it "in case a non validation error is raised, it must be raised", (validator, asyncValidator, asyncFailValidator, errorValidator) ->
        validator.add(asyncFailValidator)
        validator.add(asyncValidator)
        validator.add(errorValidator)

        expect(validator.testAsync()).hold.reject('error')

    describe "working with sync validations", ->
      it "collects errors from all failed validators", (validator, passValidator, failValidator) ->
        validator.add(failValidator)
        validator.add(passValidator)
        validator.add(failValidator)

        validator.testAsync().then (errors) ->
          expect(errors).length(2)

      it "must call the validator with the correct params", (validator, passValidator) ->
        validator.add(passValidator)

        validator.testAsync('value').then ->
          expect(passValidator.test.calledWith('value')).true

      it "in case a non validation error is raised, it must be raised", (validator, passValidator, failValidator, errorValidator) ->
        validator.add(failValidator)
        validator.add(passValidator)
        validator.add(errorValidator)

        expect(validator.testAsync()).hold.reject('error')

  describe "#multiTest", ->
    it "runs sync", ->
      validator = new MultiValidator()
      sinon.stub(validator, 'testSync').withArgs('value').returns(['error'])
      handler = sinon.stub()

      validator.multiTest('value', handler)

      expect(handler.calledWith(['error'])).true

    it "runs async", ->
      validator = new MultiValidator(async: true)
      sinon.stub(validator, 'testAsync').withArgs('value').returns(Promise.from(['error']))
      handler = sinon.stub()

      validator.multiTest('value', handler).then ->
        expect(handler.calledWith(['error'])).true

  describe "#test", ->
    it "does nothing when no fails", (validator) ->
      validator.multiTest = (value, handler) -> handler([])

      h.testPass(validator, 'value')

    it "fails when there is at least one error", (validator) ->
      validator.multiTest = (value, handler) -> handler(['err'])

      h.testFail(validator, 'value')