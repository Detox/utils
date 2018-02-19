/**
 * @package Detox utils
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
if typeof crypto != 'undefined'
	/**
	 * @param {number} size
	 *
	 * @return {!Uint8Array}
	 */
	random_bytes	= (size) ->
		array = new Uint8Array(size)
		crypto.getRandomValues(array)
		array
else
	/**
	 * @param {string} size
	 *
	 * @return {!Uint8Array}
	 */
	random_bytes	= require('crypto').randomBytes
/**
 * @param {number} min
 * @param {number} max
 *
 * @return {number}
 */
function random_int (min, max)
	bytes			= random_bytes(4)
	uint32_number	= (new Uint32Array(bytes.buffer))[0]
	Math.floor(uint32_number / 2**32 * (max - min + 1)) + min
/**
 * @template T
 *
 * @param {!Array<T>} array Returned item will be removed from this array
 *
 * @return {T}
 */
function pull_random_item_from_array (array)
	length	= array.length
	if length == 1
		array.pop()
	else
		index	= random_int(0, length - 1)
		array.splice(index, 1)[0]
/**
 * @param {!Uint8Array} array
 *
 * @return {string}
 */
function array2hex (array)
	string = ''
	for byte in array
		string += byte.toString(16).padStart(2, '0')
	string
/**
 * @param {string} string
 *
 * @return {!Uint8Array}
 */
function hex2array (string)
	array	= new Uint8Array(string.length / 2)
	for i from 0 til array.length
		array[i] = parseInt(string.substring(i * 2, i * 2 + 2), 16)
	array

var string2array, array2string
if typeof Buffer != 'undefined'
	/**
	 * @param {string} string
	 *
	 * @return {!Uint8Array}
	 */
	string2array = (string) ->
		Buffer.from(string)
	/**
	 * @param {!Uint8Array} array
	 *
	 * @return {string}
	 */
	array2string = (array) ->
		Buffer.from(array).toString()
else let encoder = new TextEncoder(), decoder = new TextDecoder()
	/**
	 * @param {string} string
	 *
	 * @return {!Uint8Array}
	 */
	string2array := (string) ->
		encoder.encode(string)
	/**
	 * @param {!Uint8Array} array
	 *
	 * @return {string}
	 */
	array2string := (array) ->
		decoder.decode(array)
/**
 * @param {string}		string
 * @param {!Uint8Array}	array
 *
 * @return {boolean}
 */
function is_string_equal_to_array (string, array)
	string == array.join(',')
/**
 * @param {!Array<!Uint8Array>} arrays
 *
 * @return {!Uint8Array}
 */
function concat_arrays (arrays)
	total_length	= arrays.reduce(
		(accumulator, array) ->
			accumulator + array.length
		0
	)
	current_offset	= 0
	result			= new Uint8Array(total_length)
	for array in arrays
		result.set(array, current_offset)
		current_offset	+= array.length
	result
/**
 * @param {!Uint8Array}	address
 * @param {!Uint8Array}	segment_id
 *
 * @return {string}
 */
function compute_source_id (address, segment_id)
	address.join(',') + segment_id.join(',')
/**
 * Changed order of arguments and delay in seconds for convenience
 */
function timeoutSet (delay, func)
	setTimeout(func, delay * 1000)
/**
 * Changed order of arguments and delay in seconds for convenience
 */
function intervalSet (delay, func)
	setInterval(func, delay * 1000)

function error_handler (error)
	if error instanceof Error
		console.error(error)

function Wrapper
	{
		'random_bytes'					: random_bytes
		'random_int'					: random_int
		'pull_random_item_from_array'	: pull_random_item_from_array
		'array2hex'						: array2hex
		'hex2array'						: hex2array
		'string2array'					: string2array
		'array2string'					: array2string
		'is_string_equal_to_array'		: is_string_equal_to_array
		'concat_arrays'					: concat_arrays
		'compute_source_id'				: compute_source_id
		'timeoutSet'					: timeoutSet
		'intervalSet'					: intervalSet
		'error_handler'					: error_handler
	}

if typeof define == 'function' && define['amd']
	# AMD
	define(Wrapper)
else if typeof exports == 'object'
	# CommonJS
	module.exports = Wrapper()
else
	# Browser globals
	@'detox_utils' = Wrapper()
