# Detox utils [![Travis CI](https://img.shields.io/travis/Detox/utils/master.svg?label=Travis%20CI)](https://travis-ci.org/Detox/utils)
Various utility functions shared between other Detox libraries.

Functions support working in Node.js as well as modern browsers

## How to install
```
npm install @detox/utils
```

## How to use
Node.js:
```javascript
var detox_utils = require('@detox/utils')

// Do stuff
```
Browser:
```javascript
requirejs(['@detox/utils'], function (detox_utils) {
    // Do stuff
})
```

## List of exported functions
* `random_bytes()`
* `random_int()`
* `sample()`
* `pull_random_item_from_array()`
* `array2hex()`
* `hex2array()`
* `string2array()`
* `array2string()`
* `are_arrays_equal()`
* `concat_arrays()`
* `timeoutSet()`
* `intervalSet()`
* `error_handler()`
* `ArrayMap()`
* `ArraySet()`
* `base58_encode()`
* `base58_decode()`

Look at source code and tests for details and usage examples.

## Contribution
Feel free to create issues and send pull requests (for big changes create an issue first and link it from the PR), they are highly appreciated!

When reading LiveScript code make sure to configure 1 tab to be 4 spaces (GitHub uses 8 by default), otherwise code might be hard to read.

## License
Free Public License 1.0.0 / Zero Clause BSD License

https://opensource.org/licenses/FPL-1.0.0

https://tldrlegal.com/license/bsd-0-clause-license
