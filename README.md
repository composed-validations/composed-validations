composed-validations
====================

[![Build Status](https://drone.io/github.com/wilkerlucio/composed-validations/status.png)](https://drone.io/github.com/wilkerlucio/composed-validations/latest)

Javascript composed validations library

Index
-----

- Introduction
- Basic Validations
- Async Validations
- Composed Validations
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

var validator = new validations.RangeValidator(10, 20)

validator.test(9); // will raise a ValidationError, since null is out of range
validator.test(10); // will just not raise any errors, since it's valid
validator.test(15); // will just not raise any errors, since it's valid
validator.test(25); // will raise a ValidationError, since null is out of range
```

So, each validator should be constructed and configured, and them it will just respond to the `test` when it's called.

The examples above are really simple ones, so, let's get into the composed validators on the next section.

Async Validations
-----------------

The async validations works pretty much the same way as sync validations, the only difference is that instead of
throwing the error right away, it will must return a `Promise`, that can resolve (we don't care on what) or get rejected
(when the validation fails).

Right now we don't provide any async validators out of the box because I couldn't find any general ones that worth to
be built-in. But it's pretty easy to implement your own, check the (creating async validators)[] section for more info
on that.

The point here is just to have you know about validators may return a `Promise` instead of raising the error right away.

We don't provide async validators, but we provide some mechanims for you to use them, we will talk more about that later
on this doc.

If you are not familiar with the `Promise` concept, this is a good place to start: [https://www.promisejs.org]()

Composed Validations
--------------------

Validating values directly is nice, gives you a lot of flexibility, but getting real, it's just not enough...

Usually you have hole structures of data, with multiple fields, sometimes deep nesting on objects, and you need to get
all this stuff to be validated togheter. This is when the composed validators come to rescue.

The idea of composed validators is: they are just validators, but instead of really validating stuff, what they do is
structural configuration of how the validators should be applied.

Enough talk, let's see an example on how to validate a complex object:

```javascript
var val = require('composed-validations'),
    PresenceValidator = val.PresenceValidator,
    FieldValidator = val.FieldValidator,
    MultiValidator = val.MultiValidator;

addressValidator = new MultiValidator();
addressValidator.add(new FieldValidator('street', new PresenceValidator());
addressValidator.add(new FieldValidator('zip', new PresenceValidator());
addressValidator.add(new FieldValidator('city', new PresenceValidator());
addressValidator.add(new FieldValidator('state', new PresenceValidator());
// the next field is optional, but if the latlong is present it will be checked
// for more details on what that means check the FieldValidator documentation
addressValidator.add(new FieldValidator('latlong', new PresenceValidator(), {optional: true}));

addressValidator.test({
  street: 'street name',
  zip: '51235',
  city: 'Tustin',
  state: 'CA'
}); // will pass, all is valid, latlong is not on data and it's optional, so all good

addressValidator.test({
  street: 'street name',
  zip: '51235',
  city: 'Tustin',
  state: 'CA',
  latlong: null
}); // this will fail, this time latlong is present, but it is invalid, so, BOOM!
```

Ok, that we introduced two new important validators here, the `MultiValidator` and the `FieldValidator`. The
`MultiValidator` makes possible to run multiple validations toghether, this is the first piece in order to handle
multiple complex object validations, you just add the validators that you need, and when you run `test(value)` on it
it will dispatch all of them. About how they are dispatched, it actually has many different strategies on how it does
that, for more information check the `MultiValidator` reference.

So note that validators that go strait into the `MultiValidator` will receive the full object to validates, when you
want go into a specific field the `FieldValidator` comes to rescue, it will narrow the context of it's contained
validator to a single field of the object. When you master the `MultiValidator` and the `FieldValidator`, you can define
really complex validation schemes just combining them, to the infinite and beyond!

Let's get it to the next level, let's compose nested validations!

```javascript
var val = require('composed-validations'),
    PresenceValidator = val.PresenceValidator,
    FieldValidator = val.FieldValidator,
    MultiValidator = val.MultiValidator;

// let's say this will import the validator from the previous example
addressValidator = require('./address_validator');

userValidator = new MultiValidator();
userValidator.add(new FieldValidator('name', new PresenceValidator());
userValidator.add(new FieldValidator('age', new RangeValidator(0, 200));
userValidator.add(new FieldValidator('userType', new IncludeValidator(['member', 'admin']));
// in fact, the address validator is just another composed validator, so just send it!
userValidator.add(new FieldValidator('address', addressValidator));

userValidator.test({
  name: 'The Guy',
  age: 26,
  userType: 'admin',
  address: {
    street: 'street name',
    zip: '51235',
    city: 'Tustin',
    state: 'CA'
  }
}); // and there you have it, all validations will go into the right places!
```

Built-in Validators
-------------------

This section documents each single validator on the framework.

Warning
-------

This library and it's documentation are in active development and design, and can still change a lot. Stay tuned.