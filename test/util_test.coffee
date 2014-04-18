_ = require('../lib/util.coffee')

describe "Util", ->
  describe "#defaults", ->
    it "extends an object from the left to right", ->
      incomeOptions =
        a: 1
        b: 2

      options = _.defaults incomeOptions,
        b: 3
        c: 4

      expect(options).eql {a: 1, b: 2, c: 4}

  describe "#isString", ->
    it "correctly detects strings", ->
      expect(_.isString(null)).false
      expect(_.isString(false)).false
      expect(_.isString({})).false
      expect(_.isString([])).false
      expect(_.isString(undefined)).false
      expect(_.isString('')).true
      expect(_.isString(' ')).true

  describe "#contains", ->
    it "test if an element is present on a list", ->
      expect(_.contains([], 1)).false
      expect(_.contains([1], 1)).true
      expect(_.contains([0, 1, 2], 0)).true
      expect(_.contains([0, 1, 2], 1)).true
      expect(_.contains([0, 1, 2], 2)).true
      expect(_.contains([0, 1, 2], 3)).false

  describe "#map", ->
    it "maps a list into another", ->
      expect(_.map([1, 2, 3], (x) -> x * 2)).eql [2, 4, 6]

  describe "#has", ->
    it "detects if a key is present on the object", ->
      obj =
        a: undefined
        b: null
        d: false
        c: true
        e: "string"
        f: 4

      expect(_.has(obj, 'a')).true
      expect(_.has(obj, 'b')).true
      expect(_.has(obj, 'c')).true
      expect(_.has(obj, 'd')).true
      expect(_.has(obj, 'e')).true
      expect(_.has(obj, 'f')).true
      expect(_.has(obj, 'g')).false