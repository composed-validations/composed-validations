(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
window.ComposedValidations = require('./index.coffee');


},{"./index.coffee":3}],2:[function(require,module,exports){
var ValidationError,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = ValidationError = (function(_super) {
  __extends(ValidationError, _super);

  function ValidationError(message) {
    this.message = message;
  }

  return ValidationError;

})(Error);


},{}],3:[function(require,module,exports){
module.exports = {
  Promise: require('promise'),
  ValidationError: require('./error.coffee'),
  FieldValidator: require('./validators/field_validator.coffee'),
  IncludeValidator: require('./validators/include_validator.coffee'),
  MultiValidator: require('./validators/multi_validator.coffee'),
  MultiAsyncValidator: require('./validators/multi_async_validator.coffee'),
  PresenceValidator: require('./validators/presence_validator.coffee'),
  RangeValidator: require('./validators/range_validator.coffee')
};


},{"./error.coffee":2,"./validators/field_validator.coffee":5,"./validators/include_validator.coffee":6,"./validators/multi_async_validator.coffee":7,"./validators/multi_validator.coffee":8,"./validators/presence_validator.coffee":9,"./validators/range_validator.coffee":10,"promise":12}],4:[function(require,module,exports){
var Promise,
  __slice = [].slice;

Promise = require('promise');

module.exports = {
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
  has: function(object, lookupKey) {
    var key, value;
    for (key in object) {
      value = object[key];
      if (key === lookupKey) {
        return true;
      }
    }
    return false;
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
  }
};


},{"promise":12}],5:[function(require,module,exports){
var FieldValidator, ValidationError, _,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

_ = require('../util.coffee');

ValidationError = require("../error.coffee");

module.exports = FieldValidator = (function() {
  function FieldValidator(field, validator, options) {
    this.field = field;
    this.validator = validator;
    if (options == null) {
      options = {};
    }
    this.test = __bind(this.test, this);
    this.options = _.defaults(options, {
      optional: false
    });
  }

  FieldValidator.prototype.async = function() {
    var _base;
    return (typeof (_base = this.validator).async === "function" ? _base.async() : void 0) || false;
  };

  FieldValidator.prototype.test = function(object) {
    var value;
    if (this.options.optional && !_.has(object, this.field)) {
      return;
    }
    if (object[this.field] == null) {
      throw new ValidationError("field " + this.field + " is not present on the object");
    }
    value = object[this.field];
    return this.validator.test(value);
  };

  return FieldValidator;

})();


},{"../error.coffee":2,"../util.coffee":4}],6:[function(require,module,exports){
var IncludeValidator, ValidationError, _,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

_ = require("../util.coffee");

ValidationError = require('../error.coffee');

module.exports = IncludeValidator = (function() {
  function IncludeValidator(possibilities) {
    this.possibilities = possibilities;
    this.test = __bind(this.test, this);
  }

  IncludeValidator.prototype.test = function(value) {
    if (!_.contains(this.possibilities, value)) {
      throw new ValidationError("" + value + " is not included on the list " + this.possibilities, this);
    }
  };

  return IncludeValidator;

})();


},{"../error.coffee":2,"../util.coffee":4}],7:[function(require,module,exports){
var MultiAsyncValidator, MultiValidator, Promise, ValidationError, _,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

_ = require("../util.coffee");

ValidationError = require('../error.coffee');

MultiValidator = require('./multi_validator.coffee');

Promise = require('promise');

module.exports = MultiAsyncValidator = (function(_super) {
  __extends(MultiAsyncValidator, _super);

  function MultiAsyncValidator() {
    this.test = __bind(this.test, this);
    return MultiAsyncValidator.__super__.constructor.apply(this, arguments);
  }

  MultiAsyncValidator.prototype.async = function() {
    return true;
  };

  MultiAsyncValidator.prototype.test = function(value) {
    var results;
    results = _.map(this.validators, function(v) {
      return _.lift(v.test)(value);
    });
    return Promise.all(results);
  };

  return MultiAsyncValidator;

})(MultiValidator);


},{"../error.coffee":2,"../util.coffee":4,"./multi_validator.coffee":8,"promise":12}],8:[function(require,module,exports){
var MultiValidator, ValidationError,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

ValidationError = require('../error.coffee');

module.exports = MultiValidator = (function() {
  function MultiValidator() {
    this.test = __bind(this.test, this);
    this.add = __bind(this.add, this);
    this.validators = [];
  }

  MultiValidator.prototype.add = function(validator) {
    if ((typeof validator.async === "function" ? validator.async() : void 0) === true) {
      throw new Error("Can't add async validators into the MultiValidator, use the MultiAsyncValidator instead.");
    }
    return this.validators.push(validator);
  };

  MultiValidator.prototype.test = function(object) {
    var validator, _i, _len, _ref, _results;
    _ref = this.validators;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      validator = _ref[_i];
      _results.push(validator.test(object));
    }
    return _results;
  };

  return MultiValidator;

})();


},{"../error.coffee":2}],9:[function(require,module,exports){
var PresenceValidator, ValidationError, trim, _,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

_ = require('../util.coffee');

ValidationError = require('../error.coffee');

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
      throw new ValidationError("" + value + " is blank");
    }
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


},{"../error.coffee":2,"../util.coffee":4}],10:[function(require,module,exports){
var RangeValidator, ValidationError,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

ValidationError = require('../error.coffee');

module.exports = RangeValidator = (function() {
  function RangeValidator(min, max) {
    this.min = min;
    this.max = max;
    this.test = __bind(this.test, this);
  }

  RangeValidator.prototype.test = function(value) {
    if (value < this.min || value > this.max) {
      throw new ValidationError("Value " + value + " is out of range [" + this.min + "," + this.max + "]");
    }
  };

  return RangeValidator;

})();


},{"../error.coffee":2}],11:[function(require,module,exports){
'use strict';

var asap = require('asap')

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

},{"asap":13}],12:[function(require,module,exports){
'use strict';

//This file contains then/promise specific extensions to the core promise API

var Promise = require('./core.js')
var asap = require('asap')

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

},{"./core.js":11,"asap":13}],13:[function(require,module,exports){
(function (process){

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


}).call(this,require("/usr/local/lib/node_modules/browserify/node_modules/insert-module-globals/node_modules/process/browser.js"))
},{"/usr/local/lib/node_modules/browserify/node_modules/insert-module-globals/node_modules/process/browser.js":14}],14:[function(require,module,exports){
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

},{}]},{},[1])