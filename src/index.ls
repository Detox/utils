/**
 * @package Detox utils
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
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
/**
 * @param {!Uint8Array}	array1
 * @param {!Uint8Array}	array2
 *
 * @return {boolean}
 */
function are_arrays_equal (array1, array2)
	if array1 == array2
		return true
	if array1.length != array2.length
		return false
	for item, key in array1
		if item != array2[key]
			return false
	true
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

function Wrapper (detox-base-x, array-map-set, random-bytes-numbers)
	random_bytes	= random-bytes-numbers['random_bytes']
	random_int		= random-bytes-numbers['random_int']
	random			= random-bytes-numbers['random']
	/**
	 * Generates exponentially distributed numbers that can be used for intervals between arrivals in Poisson process
	 *
	 * @param {number} mean
	 *
	 * @return {number}
	 */
	function sample (mean)
		-Math.log(random()) * mean
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

	# Same alphabet and format as in Bitcoin
	base58	= detox-base-x('123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz')

	{
		'random_bytes'					: random_bytes
		'random_int'					: random_int
		'sample'						: sample
		'pull_random_item_from_array'	: pull_random_item_from_array
		'array2hex'						: array2hex
		'hex2array'						: hex2array
		'string2array'					: string2array
		'array2string'					: array2string
		'are_arrays_equal'				: are_arrays_equal
		'concat_arrays'					: concat_arrays
		'timeoutSet'					: timeoutSet
		'intervalSet'					: intervalSet
		'error_handler'					: error_handler
		'ArrayMap'						: array-map-set['ArrayMap']
		'ArraySet'						: array-map-set['ArraySet']
		'base58_encode'					: base58['encode']
		'base58_decode'					: base58['decode']
	}

if typeof define == 'function' && define['amd']
	# AMD
	define(['@detox/base-x', 'array-map-set', 'random-bytes-numbers'], Wrapper)
else if typeof exports == 'object'
	# CommonJS
	module.exports = Wrapper(require('@detox/base-x'), require('array-map-set'), require('random-bytes-numbers'))
else
	# Browser globals
	@'detox_utils' = Wrapper(@'base_x', @'array_map_set', @'random_bytes_numbers')
