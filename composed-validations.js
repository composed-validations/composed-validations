/******/ (function(modules) { // webpackBootstrap
/******/ 	
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/ 		
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};
/******/ 		
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/ 		
/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;
/******/ 		
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/******/ 	
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/ 	
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/ 	
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/ 	
/******/ 	
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var klass, validator, validators, wrapConstruct, wrapped, _i, _len,
	  __slice = [].slice;

	module.exports = {
	  Promise: __webpack_require__(6),
	  _: __webpack_require__(2),
	  DelegatedValidationError: __webpack_require__(3),
	  MultiValidationError: __webpack_require__(4),
	  ValidationError: __webpack_require__(5)
	};

	validators = ['all', 'delegational', 'field', 'format', 'include', 'multi', 'negate', 'presence', 'range', 'rephrase', 'sequence', 'struct'];

	wrapConstruct = function(klass) {
	  return function() {
	    var args;
	    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
	    return (function(func, args, ctor) {
	      ctor.prototype = func.prototype;
	      var child = new ctor, result = func.apply(child, args);
	      return Object(result) === result ? result : child;
	    })(klass, args, function(){});
	  };
	};

	for (_i = 0, _len = validators.length; _i < _len; _i++) {
	  validator = validators[_i];
	  klass = __webpack_require__(1)("./" + validator + '_validator.coffee');
	  wrapped = wrapConstruct(klass);
	  wrapped.klass = klass;
	  module.exports[validator] = wrapped;
	}

	module.exports.error = wrapConstruct(module.exports.ValidationError);


/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	var map = {
		"./all_validator.coffee": 7,
		"./delegational_validator.coffee": 8,
		"./field_validator.coffee": 9,
		"./format_validator.coffee": 10,
		"./include_validator.coffee": 11,
		"./multi_validator.coffee": 12,
		"./negate_validator.coffee": 13,
		"./presence_validator.coffee": 14,
		"./range_validator.coffee": 15,
		"./rephrase_validator.coffee": 16,
		"./sequence_validator.coffee": 17,
		"./struct_validator.coffee": 18
	};
	function webpackContext(req) {
		return __webpack_require__(webpackContextResolve(req));
	};
	function webpackContextResolve(req) {
		return map[req] || (function() { throw new Error("Cannot find module '" + req + "'.") }());
	};
	webpackContext.keys = function webpackContextKeys() {
		return Object.keys(map);
	};
	webpackContext.resolve = webpackContextResolve;
	module.exports = webpackContext;


/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	var Promise, ValidationError,
	  __slice = [].slice;

	Promise = __webpack_require__(6);

	ValidationError = __webpack_require__(5);

	module.exports = {
	  json: function(obj) {
	    return JSON.stringify(obj);
	  },
	  defaults: function(object, defaults) {
	    var key, value;
	    for (key in object) {
	      value = object[key];
	      defaults[key] = value;
	    }
	    return defaults;
	  },
	  isString: function(value) {
	    return typeof value === 'string' || value && typeof value === 'object' && toString.call(value) === '[object String]' || false;
	  },
	  isFunction: function(value) {
	    return typeof value === 'function';
	  },
	  isValidator: function(value) {
	    return this.isFunction(value != null ? value.test : void 0);
	  },
	  isArray: function(value) {
	    return (value && typeof value === 'object' && typeof value.length === 'number' && toString.call(value) === '[object Array]') || false;
	  },
	  guardValidator: function(validator) {
	    if (!this.isValidator(validator)) {
	      throw new TypeError("" + (this.json(validator)) + " is not a valid validator");
	    }
	  },
	  guardValidationError: function(err) {
	    if (!(err instanceof ValidationError)) {
	      throw err;
	    }
	  },
	  contains: function(list, value) {
	    var obj, _i, _len;
	    for (_i = 0, _len = list.length; _i < _len; _i++) {
	      obj = list[_i];
	      if (obj === value) {
	        return true;
	      }
	    }
	    return false;
	  },
	  map: function(list, iterator) {
	    var newList, value, _i, _len;
	    newList = [];
	    for (_i = 0, _len = list.length; _i < _len; _i++) {
	      value = list[_i];
	      newList.push(iterator(value));
	    }
	    return newList;
	  },
	  reduce: function(list, initial, iterator) {
	    var item, _i, _len;
	    for (_i = 0, _len = list.length; _i < _len; _i++) {
	      item = list[_i];
	      initial = iterator(initial, item);
	    }
	    return initial;
	  },
	  lift: function(fn) {
	    return function() {
	      var args, err;
	      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
	      try {
	        return Promise.resolve(fn.apply(null, args));
	      } catch (_error) {
	        err = _error;
	        return Promise.reject(err);
	      }
	    };
	  },
	  humanizeFieldName: function(field) {
	    if (field.length > 0) {
	      field = field.replace(/_/g, ' ');
	      field = field.charAt(0).toUpperCase() + field.substr(1).toLowerCase();
	    }
	    return field;
	  }
	};


/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	var DelegatedValidationError, ValidationError,
	  __hasProp = {}.hasOwnProperty,
	  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

	ValidationError = __webpack_require__(5);

	module.exports = DelegatedValidationError = (function(_super) {
	  __extends(DelegatedValidationError, _super);

	  function DelegatedValidationError(message, value, childError, validator) {
	    this.childError = childError;
	    DelegatedValidationError.__super__.constructor.call(this, message, value, validator);
	  }

	  return DelegatedValidationError;

	})(ValidationError);


/***/ },
/* 4 */
/***/ function(module, exports, __webpack_require__) {

	var MultiValidationError, ValidationError, _,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
	  __hasProp = {}.hasOwnProperty,
	  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

	_ = __webpack_require__(2);

	ValidationError = __webpack_require__(5);

	module.exports = MultiValidationError = (function(_super) {
	  __extends(MultiValidationError, _super);

	  function MultiValidationError(message, value, validator, errors) {
	    this.errors = errors;
	    this.errorMessages = __bind(this.errorMessages, this);
	    MultiValidationError.__super__.constructor.call(this, this.errorMessages().join("\n"), value, validator);
	  }

	  MultiValidationError.prototype.errorMessages = function() {
	    return _.map(this.errors, (function(_this) {
	      return function(err) {
	        return err.message;
	      };
	    })(this));
	  };

	  return MultiValidationError;

	})(ValidationError);


/***/ },
/* 5 */
/***/ function(module, exports, __webpack_require__) {

	var ValidationError,
	  __hasProp = {}.hasOwnProperty,
	  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

	module.exports = ValidationError = (function(_super) {
	  __extends(ValidationError, _super);

	  function ValidationError(message, value, validator) {
	    this.message = message;
	    this.value = value;
	    this.validator = validator;
	    Error.call(this);
	    Error.captureStackTrace(this, this.constructor);
	    this.name = this.constructor.name;
	  }

	  return ValidationError;

	})(Error);


/***/ },
/* 6 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	//This file contains then/promise specific extensions to the core promise API

	var Promise = __webpack_require__(19)
	var asap = __webpack_require__(21)

	module.exports = Promise

	/* Static Functions */

	function ValuePromise(value) {
	  this.then = function (onFulfilled) {
	    if (typeof onFulfilled !== 'function') return this
	    return new Promise(function (resolve, reject) {
	      asap(function () {
	        try {
	          resolve(onFulfilled(value))
	        } catch (ex) {
	          reject(ex);
	        }
	      })
	    })
	  }
	}
	ValuePromise.prototype = Object.create(Promise.prototype)

	var TRUE = new ValuePromise(true)
	var FALSE = new ValuePromise(false)
	var NULL = new ValuePromise(null)
	var UNDEFINED = new ValuePromise(undefined)
	var ZERO = new ValuePromise(0)
	var EMPTYSTRING = new ValuePromise('')

	Promise.from = Promise.cast = function (value) {
	  if (value instanceof Promise) return value

	  if (value === null) return NULL
	  if (value === undefined) return UNDEFINED
	  if (value === true) return TRUE
	  if (value === false) return FALSE
	  if (value === 0) return ZERO
	  if (value === '') return EMPTYSTRING

	  if (typeof value === 'object' || typeof value === 'function') {
	    try {
	      var then = value.then
	      if (typeof then === 'function') {
	        return new Promise(then.bind(value))
	      }
	    } catch (ex) {
	      return new Promise(function (resolve, reject) {
	        reject(ex)
	      })
	    }
	  }

	  return new ValuePromise(value)
	}
	Promise.denodeify = function (fn, argumentCount) {
	  argumentCount = argumentCount || Infinity
	  return function () {
	    var self = this
	    var args = Array.prototype.slice.call(arguments)
	    return new Promise(function (resolve, reject) {
	      while (args.length && args.length > argumentCount) {
	        args.pop()
	      }
	      args.push(function (err, res) {
	        if (err) reject(err)
	        else resolve(res)
	      })
	      fn.apply(self, args)
	    })
	  }
	}
	Promise.nodeify = function (fn) {
	  return function () {
	    var args = Array.prototype.slice.call(arguments)
	    var callback = typeof args[args.length - 1] === 'function' ? args.pop() : null
	    try {
	      return fn.apply(this, arguments).nodeify(callback)
	    } catch (ex) {
	      if (callback === null || typeof callback == 'undefined') {
	        return new Promise(function (resolve, reject) { reject(ex) })
	      } else {
	        asap(function () {
	          callback(ex)
	        })
	      }
	    }
	  }
	}

	Promise.all = function () {
	  var args = Array.prototype.slice.call(arguments.length === 1 && Array.isArray(arguments[0]) ? arguments[0] : arguments)

	  return new Promise(function (resolve, reject) {
	    if (args.length === 0) return resolve([])
	    var remaining = args.length
	    function res(i, val) {
	      try {
	        if (val && (typeof val === 'object' || typeof val === 'function')) {
	          var then = val.then
	          if (typeof then === 'function') {
	            then.call(val, function (val) { res(i, val) }, reject)
	            return
	          }
	        }
	        args[i] = val
	        if (--remaining === 0) {
	          resolve(args);
	        }
	      } catch (ex) {
	        reject(ex)
	      }
	    }
	    for (var i = 0; i < args.length; i++) {
	      res(i, args[i])
	    }
	  })
	}

	/* Prototype Methods */

	Promise.prototype.done = function (onFulfilled, onRejected) {
	  var self = arguments.length ? this.then.apply(this, arguments) : this
	  self.then(null, function (err) {
	    asap(function () {
	      throw err
	    })
	  })
	}

	Promise.prototype.nodeify = function (callback) {
	  if (callback === null || typeof callback == 'undefined') return this

	  this.then(function (value) {
	    asap(function () {
	      callback(null, value)
	    })
	  }, function (err) {
	    asap(function () {
	      callback(err)
	    })
	  })
	}

	Promise.prototype.catch = function (onRejected) {
	  return this.then(null, onRejected);
	}


	Promise.resolve = function (value) {
	  return new Promise(function (resolve) { 
	    resolve(value);
	  });
	}

	Promise.reject = function (value) {
	  return new Promise(function (resolve, reject) { 
	    reject(value);
	  });
	}

	Promise.race = function (values) {
	  return new Promise(function (resolve, reject) { 
	    values.map(function(value){
	      Promise.cast(value).then(resolve, reject);
	    })
	  });
	}


/***/ },
/* 7 */
/***/ function(module, exports, __webpack_require__) {

	var AllValidator, DelegationalValidator, MultiValidator, Promise, ValidationError, _,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
	  __hasProp = {}.hasOwnProperty,
	  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

	Promise = __webpack_require__(6);

	_ = __webpack_require__(2);

	ValidationError = __webpack_require__(5);

	DelegationalValidator = __webpack_require__(8);

	MultiValidator = __webpack_require__(12);

	module.exports = AllValidator = (function(_super) {
	  __extends(AllValidator, _super);

	  function AllValidator() {
	    this.guardList = __bind(this.guardList, this);
	    this.testSync = __bind(this.testSync, this);
	    this.testAsync = __bind(this.testAsync, this);
	    this.test = __bind(this.test, this);
	    return AllValidator.__super__.constructor.apply(this, arguments);
	  }

	  AllValidator.prototype.test = function(list) {
	    this.guardList(list);
	    if (this.async()) {
	      return this.testAsync(list);
	    } else {
	      return this.testSync(list);
	    }
	  };

	  AllValidator.prototype.testAsync = function(list) {
	    var promises;
	    promises = _.map(list, _.lift(this.validator.test));
	    return Promise.all(promises).then((function(_this) {
	      return function() {
	        return list;
	      };
	    })(this), (function(_this) {
	      return function(err) {
	        return _this.throwError(err.message, list, err);
	      };
	    })(this));
	  };

	  AllValidator.prototype.testSync = function(list) {
	    var err, item, _i, _len;
	    try {
	      for (_i = 0, _len = list.length; _i < _len; _i++) {
	        item = list[_i];
	        this.validator.test(item);
	      }
	      return list;
	    } catch (_error) {
	      err = _error;
	      return this.throwError(err.message, list, err);
	    }
	  };

	  AllValidator.prototype.guardList = function(list) {
	    if ((list != null ? list.length : void 0) == null) {
	      throw new ValidationError("" + (_.json(list)) + " is not a list", list, this);
	    }
	  };

	  return AllValidator;

	})(DelegationalValidator);


/***/ },
/* 8 */
/***/ function(module, exports, __webpack_require__) {

	var DelegatedValidationError, DelegationalValidator, _,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

	_ = __webpack_require__(2);

	DelegatedValidationError = __webpack_require__(3);

	module.exports = DelegationalValidator = (function() {
	  function DelegationalValidator(validator) {
	    this.validator = validator;
	    this.throwError = __bind(this.throwError, this);
	    this.runValidatorSync = __bind(this.runValidatorSync, this);
	    this.runValidatorAsync = __bind(this.runValidatorAsync, this);
	    this.runValidator = __bind(this.runValidator, this);
	    _.guardValidator(this.validator);
	  }

	  DelegationalValidator.prototype.async = function() {
	    var _base;
	    return (typeof (_base = this.validator).async === "function" ? _base.async() : void 0) || false;
	  };

	  DelegationalValidator.prototype.runValidator = function(value, callback) {
	    if (this.async()) {
	      return this.runValidatorAsync(value, callback);
	    } else {
	      return this.runValidatorSync(value, callback);
	    }
	  };

	  DelegationalValidator.prototype.runValidatorAsync = function(value, callback) {
	    return this.validator.test(value).then((function(_this) {
	      return function(res) {
	        return callback(null, res);
	      };
	    })(this), (function(_this) {
	      return function(err) {
	        return callback(err);
	      };
	    })(this));
	  };

	  DelegationalValidator.prototype.runValidatorSync = function(value, callback) {
	    var err, res;
	    res = null;
	    try {
	      res = this.validator.test(value);
	    } catch (_error) {
	      err = _error;
	      return callback(err);
	    }
	    return callback(null, res);
	  };

	  DelegationalValidator.prototype.throwError = function(message, value, err) {
	    _.guardValidationError(err);
	    throw new DelegatedValidationError(message, value, err, this);
	  };

	  return DelegationalValidator;

	})();


/***/ },
/* 9 */
/***/ function(module, exports, __webpack_require__) {

	var DelegationalValidator, FieldValidator, ValidationError, _,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
	  __hasProp = {}.hasOwnProperty,
	  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

	_ = __webpack_require__(2);

	ValidationError = __webpack_require__(5);

	DelegationalValidator = __webpack_require__(8);

	module.exports = FieldValidator = (function(_super) {
	  __extends(FieldValidator, _super);

	  function FieldValidator(field, validator, options) {
	    this.field = field;
	    if (options == null) {
	      options = {};
	    }
	    this.test = __bind(this.test, this);
	    FieldValidator.__super__.constructor.call(this, validator);
	    this.options = _.defaults(options, {
	      optional: false
	    });
	  }

	  FieldValidator.prototype.test = function(object) {
	    var value;
	    if (!object) {
	      throw new ValidationError("Can't access field " + (_.json(this.field)) + " on " + (_.json(object)), object, this);
	    }
	    if (!object.hasOwnProperty(this.field)) {
	      if (this.options.optional) {
	        return object;
	      }
	      throw new ValidationError("Field " + this.field + " is not present on the object " + (_.json(object)), object, this);
	    }
	    value = object[this.field];
	    return this.runValidator(value, (function(_this) {
	      return function(err) {
	        if (err) {
	          _this.throwError("" + (_.humanizeFieldName(_this.field)) + " " + err.message, object, err, _this);
	        }
	        return object;
	      };
	    })(this));
	  };

	  return FieldValidator;

	})(DelegationalValidator);


/***/ },
/* 10 */
/***/ function(module, exports, __webpack_require__) {

	var FormatValidator, ValidationError,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

	ValidationError = __webpack_require__(5);

	module.exports = FormatValidator = (function() {
	  function FormatValidator(format) {
	    this.format = format;
	    this.test = __bind(this.test, this);
	  }

	  FormatValidator.prototype.test = function(value) {
	    if (!this.format.exec(value)) {
	      throw new ValidationError("format is not valid", value, this);
	    }
	    return value;
	  };

	  return FormatValidator;

	})();


/***/ },
/* 11 */
/***/ function(module, exports, __webpack_require__) {

	var IncludeValidator, ValidationError, _,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

	_ = __webpack_require__(2);

	ValidationError = __webpack_require__(5);

	module.exports = IncludeValidator = (function() {
	  function IncludeValidator(possibilities) {
	    this.possibilities = possibilities;
	    this.test = __bind(this.test, this);
	  }

	  IncludeValidator.prototype.test = function(value) {
	    if (!_.contains(this.possibilities, value)) {
	      throw new ValidationError("" + (_.json(value)) + " is not included on the list " + (_.json(this.possibilities)), value, this);
	    }
	    return value;
	  };

	  return IncludeValidator;

	})();


/***/ },
/* 12 */
/***/ function(module, exports, __webpack_require__) {

	var MultiValidationError, MultiValidator, Promise, _,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

	_ = __webpack_require__(2);

	MultiValidationError = __webpack_require__(4);

	Promise = __webpack_require__(6);

	module.exports = MultiValidator = (function() {
	  function MultiValidator(options) {
	    if (options == null) {
	      options = {};
	    }
	    this.guardAsync = __bind(this.guardAsync, this);
	    this.testAsync = __bind(this.testAsync, this);
	    this.testSync = __bind(this.testSync, this);
	    this.multiTest = __bind(this.multiTest, this);
	    this.test = __bind(this.test, this);
	    this.add = __bind(this.add, this);
	    this.async = __bind(this.async, this);
	    this.options = _.defaults(options, {
	      async: false
	    });
	    this.validators = [];
	  }

	  MultiValidator.prototype.async = function() {
	    return this.options.async;
	  };

	  MultiValidator.prototype.add = function(validator) {
	    _.guardValidator(validator);
	    this.guardAsync(validator);
	    this.validators.push(validator);
	    return this;
	  };

	  MultiValidator.prototype.test = function(value) {
	    return this.multiTest(value, (function(_this) {
	      return function(errors) {
	        if (errors.length > 0) {
	          throw new MultiValidationError(null, value, _this, errors);
	        }
	        return value;
	      };
	    })(this));
	  };

	  MultiValidator.prototype.multiTest = function(value, handler) {
	    if (this.async()) {
	      return this.testAsync(value).then(handler);
	    } else {
	      return handler(this.testSync(value));
	    }
	  };

	  MultiValidator.prototype.testSync = function(value) {
	    var err, errors, validator, _i, _len, _ref;
	    errors = [];
	    _ref = this.validators;
	    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
	      validator = _ref[_i];
	      try {
	        validator.test(value);
	      } catch (_error) {
	        err = _error;
	        _.guardValidationError(err);
	        errors.push(err);
	      }
	    }
	    return errors;
	  };

	  MultiValidator.prototype.testAsync = function(value) {
	    var errors, results;
	    errors = [];
	    results = _.map(this.validators, (function(_this) {
	      return function(v) {
	        return _.lift(function(value) {
	          return v.test(value);
	        })(value).then(void 0, function(err) {
	          _.guardValidationError(err);
	          errors.push(err);
	          return null;
	        });
	      };
	    })(this));
	    return Promise.all(results).then(function() {
	      return errors;
	    });
	  };

	  MultiValidator.prototype.guardAsync = function(validator) {
	    if ((typeof validator.async === "function" ? validator.async() : void 0) === true && !this.async()) {
	      throw new Error("Can't add async validators into a sync MultiValitor, use the {sync: true} option to allow async validators to be added.");
	    }
	  };

	  return MultiValidator;

	})();


/***/ },
/* 13 */
/***/ function(module, exports, __webpack_require__) {

	var DelegationalValidator, NegateValidator, ValidationError,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
	  __hasProp = {}.hasOwnProperty,
	  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

	ValidationError = __webpack_require__(5);

	DelegationalValidator = __webpack_require__(8);

	module.exports = NegateValidator = (function(_super) {
	  __extends(NegateValidator, _super);

	  function NegateValidator() {
	    this.test = __bind(this.test, this);
	    return NegateValidator.__super__.constructor.apply(this, arguments);
	  }

	  NegateValidator.prototype.test = function(value) {
	    return this.runValidator(value, (function(_this) {
	      return function(err) {
	        var childError;
	        if (!err) {
	          childError = new ValidationError("", value, _this);
	          _this.throwError("validation negated failed", value, childError, _this);
	        }
	        return value;
	      };
	    })(this));
	  };

	  return NegateValidator;

	})(DelegationalValidator);


/***/ },
/* 14 */
/***/ function(module, exports, __webpack_require__) {

	var PresenceValidator, ValidationError, trim, _,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

	_ = __webpack_require__(2);

	ValidationError = __webpack_require__(5);

	trim = function(string) {
	  return string.replace(/^\s+|\s+$/g, '');
	};

	module.exports = PresenceValidator = (function() {
	  function PresenceValidator() {
	    this.normalize = __bind(this.normalize, this);
	    this.test = __bind(this.test, this);
	  }

	  PresenceValidator.prototype.test = function(value) {
	    if (!this.normalize(value)) {
	      throw new ValidationError("can't be blank", value, this);
	    }
	    return value;
	  };

	  PresenceValidator.prototype.normalize = function(value) {
	    if (_.isString(value)) {
	      return trim(value);
	    } else {
	      return value;
	    }
	  };

	  return PresenceValidator;

	})();


/***/ },
/* 15 */
/***/ function(module, exports, __webpack_require__) {

	var RangeValidator, ValidationError, _,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

	_ = __webpack_require__(2);

	ValidationError = __webpack_require__(5);

	module.exports = RangeValidator = (function() {
	  function RangeValidator(min, max) {
	    this.min = min;
	    this.max = max;
	    this.test = __bind(this.test, this);
	    if (this.min > this.max) {
	      throw new Error("Range Validator: input min (" + this.min + ") is bigger than the max (" + this.max + ")");
	    }
	  }

	  RangeValidator.prototype.test = function(value) {
	    if (value < this.min) {
	      throw new ValidationError("needs to be bigger than " + (_.json(this.min)), value, this);
	    }
	    if (value > this.max) {
	      throw new ValidationError("needs to be lower than " + (_.json(this.max)), value, this);
	    }
	    return value;
	  };

	  return RangeValidator;

	})();


/***/ },
/* 16 */
/***/ function(module, exports, __webpack_require__) {

	var DelegationalValidator, RephraseValidator,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
	  __hasProp = {}.hasOwnProperty,
	  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

	DelegationalValidator = __webpack_require__(8);

	module.exports = RephraseValidator = (function(_super) {
	  __extends(RephraseValidator, _super);

	  function RephraseValidator(message, validator) {
	    this.message = message;
	    this.test = __bind(this.test, this);
	    RephraseValidator.__super__.constructor.call(this, validator);
	  }

	  RephraseValidator.prototype.test = function(value) {
	    return this.runValidator(value, (function(_this) {
	      return function(err) {
	        if (err) {
	          err.message = _this.message;
	          throw err;
	        }
	        return value;
	      };
	    })(this));
	  };

	  return RephraseValidator;

	})(DelegationalValidator);


/***/ },
/* 17 */
/***/ function(module, exports, __webpack_require__) {

	var MultiValidator, Promise, SequenceValidator, _,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
	  __hasProp = {}.hasOwnProperty,
	  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

	_ = __webpack_require__(2);

	MultiValidator = __webpack_require__(12);

	Promise = __webpack_require__(6);

	module.exports = SequenceValidator = (function(_super) {
	  __extends(SequenceValidator, _super);

	  function SequenceValidator() {
	    this.testAsync = __bind(this.testAsync, this);
	    this.testSync = __bind(this.testSync, this);
	    this.test = __bind(this.test, this);
	    return SequenceValidator.__super__.constructor.apply(this, arguments);
	  }

	  SequenceValidator.prototype.test = function(value) {
	    if (this.async()) {
	      return this.testAsync(value);
	    } else {
	      return this.testSync(value);
	    }
	  };

	  SequenceValidator.prototype.testSync = function(value) {
	    return _.reduce(this.validators, value, function(acc, validator) {
	      return validator.test(acc);
	    });
	  };

	  SequenceValidator.prototype.testAsync = function(value) {
	    return _.reduce(this.validators, Promise.from(value), function(promise, validator) {
	      return promise.then(function(acc) {
	        return validator.test(acc);
	      });
	    });
	  };

	  return SequenceValidator;

	})(MultiValidator);


/***/ },
/* 18 */
/***/ function(module, exports, __webpack_require__) {

	var FieldValidator, MultiValidator, RephraseValidator, StructValidationError, StructValidator, _,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
	  __hasProp = {}.hasOwnProperty,
	  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
	  __slice = [].slice;

	_ = __webpack_require__(2);

	MultiValidator = __webpack_require__(12);

	FieldValidator = __webpack_require__(9);

	RephraseValidator = __webpack_require__(16);

	StructValidationError = __webpack_require__(20);

	module.exports = StructValidator = (function(_super) {
	  __extends(StructValidator, _super);

	  function StructValidator() {
	    this._wrapErrorMessage = __bind(this._wrapErrorMessage, this);
	    this._wrapFieldValidator = __bind(this._wrapFieldValidator, this);
	    this.validatorForField = __bind(this.validatorForField, this);
	    this.testField = __bind(this.testField, this);
	    this.addFieldValidator = __bind(this.addFieldValidator, this);
	    this.addAssociated = __bind(this.addAssociated, this);
	    this.test = __bind(this.test, this);
	    this.validate = __bind(this.validate, this);
	    StructValidator.__super__.constructor.apply(this, arguments);
	    this.fieldValidators = {};
	  }

	  StructValidator.prototype.validate = function() {
	    var errorMessage, field, fields, validator, wrapped, _i, _j, _len;
	    fields = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), validator = arguments[_i++];
	    if (arguments.length > 2 && _.isString(validator)) {
	      errorMessage = validator;
	      validator = fields.pop();
	    }
	    for (_j = 0, _len = fields.length; _j < _len; _j++) {
	      field = fields[_j];
	      wrapped = this._wrapFieldValidator(field, validator);
	      if (errorMessage) {
	        wrapped = this._wrapErrorMessage(errorMessage, wrapped);
	      }
	      this.addAssociated(field, wrapped);
	    }
	    return this;
	  };

	  StructValidator.prototype.test = function(value) {
	    return this.multiTest(value, (function(_this) {
	      return function(errors) {
	        if (errors.length > 0) {
	          throw new StructValidationError(null, value, _this, errors);
	        }
	        return value;
	      };
	    })(this));
	  };

	  StructValidator.prototype.addAssociated = function() {
	    var field, fields, validator, _i, _j, _len;
	    fields = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), validator = arguments[_i++];
	    this.add(validator);
	    for (_j = 0, _len = fields.length; _j < _len; _j++) {
	      field = fields[_j];
	      this.addFieldValidator(field, validator);
	    }
	    return this;
	  };

	  StructValidator.prototype.addFieldValidator = function() {
	    var field, fields, validator, _base, _i, _j, _len;
	    fields = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), validator = arguments[_i++];
	    _.guardValidator(validator);
	    for (_j = 0, _len = fields.length; _j < _len; _j++) {
	      field = fields[_j];
	      (_base = this.fieldValidators)[field] || (_base[field] = new MultiValidator(this.options));
	      this.fieldValidators[field].add(validator);
	    }
	    return this;
	  };

	  StructValidator.prototype.testField = function(field, value) {
	    return this.validatorForField(field).test(value);
	  };

	  StructValidator.prototype.validatorForField = function(field) {
	    var validators;
	    if (!(validators = this.fieldValidators[field])) {
	      throw new Error("There are no validators associated with the field " + (_.json(field)));
	    }
	    return validators;
	  };

	  StructValidator.prototype._wrapFieldValidator = function(field, validator) {
	    return new FieldValidator(field, validator);
	  };

	  StructValidator.prototype._wrapErrorMessage = function(message, validator) {
	    return new RephraseValidator(message, validator);
	  };

	  return StructValidator;

	})(MultiValidator);


/***/ },
/* 19 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var asap = __webpack_require__(21)

	module.exports = Promise
	function Promise(fn) {
	  if (typeof this !== 'object') throw new TypeError('Promises must be constructed via new')
	  if (typeof fn !== 'function') throw new TypeError('not a function')
	  var state = null
	  var value = null
	  var deferreds = []
	  var self = this

	  this.then = function(onFulfilled, onRejected) {
	    return new Promise(function(resolve, reject) {
	      handle(new Handler(onFulfilled, onRejected, resolve, reject))
	    })
	  }

	  function handle(deferred) {
	    if (state === null) {
	      deferreds.push(deferred)
	      return
	    }
	    asap(function() {
	      var cb = state ? deferred.onFulfilled : deferred.onRejected
	      if (cb === null) {
	        (state ? deferred.resolve : deferred.reject)(value)
	        return
	      }
	      var ret
	      try {
	        ret = cb(value)
	      }
	      catch (e) {
	        deferred.reject(e)
	        return
	      }
	      deferred.resolve(ret)
	    })
	  }

	  function resolve(newValue) {
	    try { //Promise Resolution Procedure: https://github.com/promises-aplus/promises-spec#the-promise-resolution-procedure
	      if (newValue === self) throw new TypeError('A promise cannot be resolved with itself.')
	      if (newValue && (typeof newValue === 'object' || typeof newValue === 'function')) {
	        var then = newValue.then
	        if (typeof then === 'function') {
	          doResolve(then.bind(newValue), resolve, reject)
	          return
	        }
	      }
	      state = true
	      value = newValue
	      finale()
	    } catch (e) { reject(e) }
	  }

	  function reject(newValue) {
	    state = false
	    value = newValue
	    finale()
	  }

	  function finale() {
	    for (var i = 0, len = deferreds.length; i < len; i++)
	      handle(deferreds[i])
	    deferreds = null
	  }

	  doResolve(fn, resolve, reject)
	}


	function Handler(onFulfilled, onRejected, resolve, reject){
	  this.onFulfilled = typeof onFulfilled === 'function' ? onFulfilled : null
	  this.onRejected = typeof onRejected === 'function' ? onRejected : null
	  this.resolve = resolve
	  this.reject = reject
	}

	/**
	 * Take a potentially misbehaving resolver function and make sure
	 * onFulfilled and onRejected are only called once.
	 *
	 * Makes no guarantees about asynchrony.
	 */
	function doResolve(fn, onFulfilled, onRejected) {
	  var done = false;
	  try {
	    fn(function (value) {
	      if (done) return
	      done = true
	      onFulfilled(value)
	    }, function (reason) {
	      if (done) return
	      done = true
	      onRejected(reason)
	    })
	  } catch (ex) {
	    if (done) return
	    done = true
	    onRejected(ex)
	  }
	}


/***/ },
/* 20 */
/***/ function(module, exports, __webpack_require__) {

	var MultiValidationError, StructValidationError,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
	  __hasProp = {}.hasOwnProperty,
	  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

	MultiValidationError = __webpack_require__(4);

	module.exports = StructValidationError = (function(_super) {
	  __extends(StructValidationError, _super);

	  function StructValidationError() {
	    this.indexFieldErros = __bind(this.indexFieldErros, this);
	    StructValidationError.__super__.constructor.apply(this, arguments);
	    this.indexFieldErros();
	  }

	  StructValidationError.prototype.indexFieldErros = function() {
	    var assigned, err, field, multiVal, _base, _i, _len, _ref, _ref1;
	    this.generalErrors = [];
	    this.fieldErrors = {};
	    _ref = this.errors;
	    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
	      err = _ref[_i];
	      assigned = false;
	      _ref1 = this.validator.fieldValidators;
	      for (field in _ref1) {
	        multiVal = _ref1[field];
	        (_base = this.fieldErrors)[field] || (_base[field] = []);
	        if (multiVal.validators.indexOf(err.validator) > -1) {
	          this.fieldErrors[field].push(err);
	          assigned = true;
	        }
	      }
	      if (!assigned) {
	        this.generalErrors.push(err);
	      }
	    }
	    return this;
	  };

	  return StructValidationError;

	})(MultiValidationError);


/***/ },
/* 21 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(process) {
	// Use the fastest possible means to execute a task in a future turn
	// of the event loop.

	// linked list of tasks (single, with head node)
	var head = {task: void 0, next: null};
	var tail = head;
	var flushing = false;
	var requestFlush = void 0;
	var isNodeJS = false;

	function flush() {
	    /* jshint loopfunc: true */

	    while (head.next) {
	        head = head.next;
	        var task = head.task;
	        head.task = void 0;
	        var domain = head.domain;

	        if (domain) {
	            head.domain = void 0;
	            domain.enter();
	        }

	        try {
	            task();

	        } catch (e) {
	            if (isNodeJS) {
	                // In node, uncaught exceptions are considered fatal errors.
	                // Re-throw them synchronously to interrupt flushing!

	                // Ensure continuation if the uncaught exception is suppressed
	                // listening "uncaughtException" events (as domains does).
	                // Continue in next event to avoid tick recursion.
	                if (domain) {
	                    domain.exit();
	                }
	                setTimeout(flush, 0);
	                if (domain) {
	                    domain.enter();
	                }

	                throw e;

	            } else {
	                // In browsers, uncaught exceptions are not fatal.
	                // Re-throw them asynchronously to avoid slow-downs.
	                setTimeout(function() {
	                   throw e;
	                }, 0);
	            }
	        }

	        if (domain) {
	            domain.exit();
	        }
	    }

	    flushing = false;
	}

	if (typeof process !== "undefined" && process.nextTick) {
	    // Node.js before 0.9. Note that some fake-Node environments, like the
	    // Mocha test runner, introduce a `process` global without a `nextTick`.
	    isNodeJS = true;

	    requestFlush = function () {
	        process.nextTick(flush);
	    };

	} else if (typeof setImmediate === "function") {
	    // In IE10, Node.js 0.9+, or https://github.com/NobleJS/setImmediate
	    if (typeof window !== "undefined") {
	        requestFlush = setImmediate.bind(window, flush);
	    } else {
	        requestFlush = function () {
	            setImmediate(flush);
	        };
	    }

	} else if (typeof MessageChannel !== "undefined") {
	    // modern browsers
	    // http://www.nonblocking.io/2011/06/windownexttick.html
	    var channel = new MessageChannel();
	    channel.port1.onmessage = flush;
	    requestFlush = function () {
	        channel.port2.postMessage(0);
	    };

	} else {
	    // old browsers
	    requestFlush = function () {
	        setTimeout(flush, 0);
	    };
	}

	function asap(task) {
	    tail = tail.next = {
	        task: task,
	        domain: isNodeJS && process.domain,
	        next: null
	    };

	    if (!flushing) {
	        flushing = true;
	        requestFlush();
	    }
	};

	module.exports = asap;

	
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(22)))

/***/ },
/* 22 */
/***/ function(module, exports, __webpack_require__) {

	// shim for using process in browser

	var process = module.exports = {};

	process.nextTick = (function () {
	    var canSetImmediate = typeof window !== 'undefined'
	    && window.setImmediate;
	    var canPost = typeof window !== 'undefined'
	    && window.postMessage && window.addEventListener
	    ;

	    if (canSetImmediate) {
	        return function (f) { return window.setImmediate(f) };
	    }

	    if (canPost) {
	        var queue = [];
	        window.addEventListener('message', function (ev) {
	            var source = ev.source;
	            if ((source === window || source === null) && ev.data === 'process-tick') {
	                ev.stopPropagation();
	                if (queue.length > 0) {
	                    var fn = queue.shift();
	                    fn();
	                }
	            }
	        }, true);

	        return function nextTick(fn) {
	            queue.push(fn);
	            window.postMessage('process-tick', '*');
	        };
	    }

	    return function nextTick(fn) {
	        setTimeout(fn, 0);
	    };
	})();

	process.title = 'browser';
	process.browser = true;
	process.env = {};
	process.argv = [];

	function noop() {}

	process.on = noop;
	process.once = noop;
	process.off = noop;
	process.emit = noop;

	process.binding = function (name) {
	    throw new Error('process.binding is not supported');
	}

	// TODO(shtylman)
	process.cwd = function () { return '/' };
	process.chdir = function (dir) {
	    throw new Error('process.chdir is not supported');
	};


/***/ }
/******/ ])