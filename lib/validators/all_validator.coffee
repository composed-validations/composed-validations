Promise = require('promise')

_ = require('../util.coffee')
ValidationError = require('../errors/validation_error.coffee')
DelegationalValidator = require('./delegational_validator.coffee')
MultiValidator = require('./multi_validator.coffee')

module.exports = class AllValidator extends DelegationalValidator
  test: (list) =>
    @guardList(list)

    if @async()
      @testAsync(list)
    else
      @testSync(list)

  testAsync: (list) =>
    promises = _.map(list, _.lift(@validator.test))

    Promise.all(promises).then(
      => list
      (err) => @throwError(err.message, list, err)
    )

  testSync: (list) =>
    try
      for item in list
        @validator.test(item)

      list
    catch err
      @throwError(err.message, list, err)

  guardList: (list) =>
    unless list?.length?
      throw new ValidationError("#{_.json list} is not a list", list, this)
