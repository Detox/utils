// Generated by LiveScript 1.5.0
/**
 * @package Detox utils
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
(function(){
  var random_bytes, string2array, array2string;
  if (typeof crypto !== 'undefined') {
    /**
     * @param {number} size
     *
     * @return {!Uint8Array}
     */
    random_bytes = function(size){
      var array;
      array = new Uint8Array(size);
      crypto.getRandomValues(array);
      return array;
    };
  } else {
    /**
     * @param {string} size
     *
     * @return {!Uint8Array}
     */
    random_bytes = require('crypto').randomBytes;
  }
  /**
   * @param {number} min
   * @param {number} max
   *
   * @return {number}
   */
  function random_int(min, max){
    var bytes, uint32_number;
    bytes = random_bytes(4);
    uint32_number = new Uint32Array(bytes.buffer)[0];
    return Math.floor(uint32_number / Math.pow(2, 32) * (max - min + 1)) + min;
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
   * @param {string}		string
   * @param {!Uint8Array}	array
   *
   * @return {boolean}
   */
  function is_string_equal_to_array(string, array){
    return string === array.join(',');
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
   * @param {!Uint8Array}	address
   * @param {!Uint8Array}	segment_id
   *
   * @return {string}
   */
  function compute_source_id(address, segment_id){
    return address.join(',') + segment_id.join(',');
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
  function Wrapper(){
    return {
      'random_bytes': random_bytes,
      'random_int': random_int,
      'pull_random_item_from_array': pull_random_item_from_array,
      'array2hex': array2hex,
      'hex2array': hex2array,
      'string2array': string2array,
      'array2string': array2string,
      'is_string_equal_to_array': is_string_equal_to_array,
      'concat_arrays': concat_arrays,
      'compute_source_id': compute_source_id,
      'timeoutSet': timeoutSet,
      'intervalSet': intervalSet,
      'error_handler': error_handler
    };
  }
  if (typeof define === 'function' && define['amd']) {
    define(Wrapper);
  } else if (typeof exports === 'object') {
    module.exports = Wrapper();
  } else {
    this['detox_utils'] = Wrapper();
  }
}).call(this);
