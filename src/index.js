// Generated by LiveScript 1.5.0
/**
 * @package Detox utils
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
(function(){
  var string2array, array2string, key_aliases, key_strings, key_usages;
  if (typeof Buffer !== 'undefined') {
    /**
     * @param {string} string
     *
     * @return {!Uint8Array}
     */
    string2array = function(string){
      return Buffer.from(string);
    };
    /**
     * @param {!Uint8Array} array
     *
     * @return {string}
     */
    array2string = function(array){
      return Buffer.from(array).toString();
    };
  } else {
    (function(encoder, decoder){
      /**
       * @param {string} string
       *
       * @return {!Uint8Array}
       */
      string2array = function(string){
        return encoder.encode(string);
      };
      /**
       * @param {!Uint8Array} array
       *
       * @return {string}
       */
      array2string = function(array){
        return decoder.decode(array);
      };
    }.call(this, new TextEncoder(), new TextDecoder()));
  }
  /**
   * @param {!Uint8Array} array
   *
   * @return {string}
   */
  function array2hex(array){
    var string, i$, len$, byte;
    string = '';
    for (i$ = 0, len$ = array.length; i$ < len$; ++i$) {
      byte = array[i$];
      string += byte.toString(16).padStart(2, '0');
    }
    return string;
  }
  /**
   * @param {string} string
   *
   * @return {!Uint8Array}
   */
  function hex2array(string){
    var array, i$, to$, i;
    array = new Uint8Array(string.length / 2);
    for (i$ = 0, to$ = array.length; i$ < to$; ++i$) {
      i = i$;
      array[i] = parseInt(string.substring(i * 2, i * 2 + 2), 16);
    }
    return array;
  }
  /**
   * @param {!Uint8Array}	array1
   * @param {!Uint8Array}	array2
   *
   * @return {boolean}
   */
  function are_arrays_equal(array1, array2){
    var i$, len$, key, item;
    if (array1 === array2) {
      return true;
    }
    if (array1.length !== array2.length) {
      return false;
    }
    for (i$ = 0, len$ = array1.length; i$ < len$; ++i$) {
      key = i$;
      item = array1[i$];
      if (item !== array2[key]) {
        return false;
      }
    }
    return true;
  }
  /**
   * @param {!Array<!Uint8Array>} arrays
   *
   * @return {!Uint8Array}
   */
  function concat_arrays(arrays){
    var total_length, current_offset, result, i$, len$, array;
    total_length = arrays.reduce(function(accumulator, array){
      return accumulator + array.length;
    }, 0);
    current_offset = 0;
    result = new Uint8Array(total_length);
    for (i$ = 0, len$ = arrays.length; i$ < len$; ++i$) {
      array = arrays[i$];
      result.set(array, current_offset);
      current_offset += array.length;
    }
    return result;
  }
  /**
   * Changed order of arguments and delay in seconds for convenience
   */
  function timeoutSet(delay, func){
    return setTimeout(func, delay * 1000);
  }
  /**
   * Changed order of arguments and delay in seconds for convenience
   */
  function intervalSet(delay, func){
    return setInterval(func, delay * 1000);
  }
  function error_handler(error){
    if (error instanceof Error) {
      return console.error(error);
    }
  }
  key_aliases = new WeakMap;
  key_strings = new Map;
  key_usages = new Map;
  /**
   * @param {!Uint8Array} key
   *
   * @return {!Uint8Array}
   */
  function get_unique_key(key){
    var real_key, key_string;
    real_key = key_aliases.get(key);
    /**
     * Real key is an array with unique contents that appeared first.
     * If all of the usages were eliminated, some WeakMap can still point to old real key, which is not a real key anymore, which leads to inconsistencies.
     * In order to resolve this we have an additional check that confirms if real key is still believed to be a real key.
     */
    if (real_key && key_usages.has(real_key)) {
      return real_key;
    } else {
      key_string = key.join(',');
      if (key_strings.has(key_string)) {
        real_key = key_strings.get(key_string);
        key_aliases.set(key, real_key);
        return real_key;
      } else {
        return key;
      }
    }
  }
  /**
   * @param {!Uint8Array} key
   */
  function increase_key_usage(key){
    var key_string, current_value;
    key_string = key.join(',');
    current_value = key_usages.get(key);
    if (!current_value) {
      key_aliases.set(key, key);
      key_strings.set(key_string, key);
      key_usages.set(key, 1);
    } else {
      ++current_value;
      key_usages.set(key, current_value);
    }
  }
  /**
   * @param {!Uint8Array} key
   */
  function decrease_key_usage(key){
    var key_string, current_value;
    key_string = key.join(',');
    current_value = key_usages.get(key);
    --current_value;
    if (!current_value) {
      key_strings['delete'](key_string);
      key_usages['delete'](key);
    } else {
      key_usages.set(key, current_value);
    }
  }
  /**
   * This is a Map with very interesting property: different arrays with the same contents will be treated as the same array
   *
   * Implementation keeps weak references to make the whole thing fast and efficient
   */
  function ArrayMap(array){
    var x$, map, i$, len$, ref$, key, value;
    x$ = map = new Map;
    x$.get = function(key){
      key = get_unique_key(key);
      return Map.prototype.get.call(this, key);
    };
    x$.has = function(key){
      key = get_unique_key(key);
      return Map.prototype.has.call(this, key);
    };
    x$.set = function(key, value){
      key = get_unique_key(key);
      if (!Map.prototype.has.call(this, key)) {
        increase_key_usage(key);
      }
      return Map.prototype.set.call(this, key, value);
    };
    x$['delete'] = function(key){
      key = get_unique_key(key);
      if (Map.prototype.has.call(this, key)) {
        decrease_key_usage(key);
      }
      return Map.prototype['delete'].call(this, key);
    };
    x$.clear = function(){
      var this$ = this;
      this.forEach(function(arg$, key){
        this$['delete'](key);
      });
    };
    if (array) {
      for (i$ = 0, len$ = array.length; i$ < len$; ++i$) {
        ref$ = array[i$], key = ref$[0], value = ref$[1];
        map.set(key, value);
      }
    }
    return map;
  }
  /**
   * This is a Set with very interesting property: different arrays with the same contents will be treated as the same array
   *
   * Implementation keeps weak references to make the whole thing fast and efficient
   */
  function ArraySet(array){
    var x$, set, i$, len$, item;
    x$ = set = new Set;
    x$.has = function(key){
      key = get_unique_key(key);
      return Set.prototype.has.call(this, key);
    };
    x$.add = function(key){
      key = get_unique_key(key);
      if (!Set.prototype.has.call(this, key)) {
        increase_key_usage(key);
      }
      return Set.prototype.add.call(this, key);
    };
    x$['delete'] = function(key){
      key = get_unique_key(key);
      if (Set.prototype.has.call(this, key)) {
        decrease_key_usage(key);
      }
      return Set.prototype['delete'].call(this, key);
    };
    x$.clear = function(){
      var this$ = this;
      this.forEach(function(arg$, key){
        this$['delete'](key);
      });
    };
    if (array) {
      for (i$ = 0, len$ = array.length; i$ < len$; ++i$) {
        item = array[i$];
        set.add(item);
      }
    }
    return set;
  }
  function Wrapper(detoxBaseX, randomBytesNumbers){
    var random_bytes, random_int, random, base58;
    random_bytes = randomBytesNumbers['random_bytes'];
    random_int = randomBytesNumbers['random_int'];
    random = randomBytesNumbers['random'];
    /**
     * Generates exponentially distributed numbers that can be used for intervals between arrivals in Poisson process
     *
     * @param {number} mean
     *
     * @return {number}
     */
    function sample(mean){
      return -Math.log(random()) * mean;
    }
    /**
     * @template T
     *
     * @param {!Array<T>} array Returned item will be removed from this array
     *
     * @return {T}
     */
    function pull_random_item_from_array(array){
      var length, index;
      length = array.length;
      if (length === 1) {
        return array.pop();
      } else {
        index = random_int(0, length - 1);
        return array.splice(index, 1)[0];
      }
    }
    base58 = detoxBaseX('123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz');
    return {
      'random_bytes': random_bytes,
      'random_int': random_int,
      'sample': sample,
      'pull_random_item_from_array': pull_random_item_from_array,
      'array2hex': array2hex,
      'hex2array': hex2array,
      'string2array': string2array,
      'array2string': array2string,
      'are_arrays_equal': are_arrays_equal,
      'concat_arrays': concat_arrays,
      'timeoutSet': timeoutSet,
      'intervalSet': intervalSet,
      'error_handler': error_handler,
      'ArrayMap': ArrayMap,
      'ArraySet': ArraySet,
      'base58_encode': base58['encode'],
      'base58_decode': base58['decode']
    };
  }
  if (typeof define === 'function' && define['amd']) {
    define(['@detox/base-x', 'random-bytes-numbers'], Wrapper);
  } else if (typeof exports === 'object') {
    module.exports = Wrapper(require('@detox/base-x'), require('random-bytes-numbers'));
  } else {
    this['detox_utils'] = Wrapper(this['base_x'], this['random_bytes_numbers']);
  }
}).call(this);
