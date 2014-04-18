[![Build Status](https://drone.io/github.com/wilkerlucio/composed-validations/status.png)](https://drone.io/github.com/wilkerlucio/composed-validations/latest)

composed-validations
====================

Javascript composed validations library

Index
-----

- Introduction
- Basic Validations
- Async Validations
- Composed Validations
  - composing sync validations
  - composing async validations
- Built-in validators
  - Leaf validators
    - PresenceValidator
    - RangeValidator
    - IncludeValidator
    - TypeValidator
    - InstanceOfValidator
  - Compositional validators
    - NegateValidator
    - FieldValidator
    - MultiValidator
    - ListValidator
    - MultifieldValidator
- Creating custom validators
  - creating sync validators
  - creating async validators
- Case Study: validating user signup on server and client side with same configuration

Introduction
------------

Before we see any code, I would first like to explain the basis of `composed-validations`.

The entire framework works around a really simple interface, remember that, it is:

```javascript
validator.test(value);
```

All of the validators responds to this interface, and each validator is a single small piece that just validates a
single value. In order to validate complex values, you use `compositional validators` that will compose your complex
validation. It follow the design pattern `Composite`, where a single or composite validators can be thread as the same
thing, and what bounds them is the interface we just talked about. These ideas will become more clear as we go further
on this documentation. Now let me show you the code!

Basic validations
-----------------

Let's start with the simplest validations that just checks if a value is present:

```javascript
var validations = require('composed-validations');

var validator = new validations.PresenceValidator()

validator.test(null); // will raise a ValidationError, since null is not a present value
validator.test('ok'); // will just not raise any errors, since it's valid
```

And let's look at one more, just for the sake of exemplify:

```javascript
var validations = require('composed-validations');

var validator = new validations.PresenceValidator()

validator.test(null); // will raise a ValidationError, since null is not a present value
validator.test('ok'); // will just not raise any errors, since it's valid
```