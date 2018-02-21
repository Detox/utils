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

key_aliases	= new WeakMap
key_strings	= new Map
key_usages	= new Map
/**
 * @param {!Uint8Array} key
 *
 * @return {!Uint8Array}
 */
function get_unique_key (key)
	real_key = key_aliases.get(key)
	/**
	 * Real key is an array with unique contents that appeared first.
	 * If all of the usages were eliminated, some WeakMap can still point to old real key, which is not a real key anymore, which leads to inconsistencies.
	 * In order to resolve this we have an additional check that confirms if real key is still believed to be a real key.
	 */
	if real_key && key_usages.has(real_key)
		real_key
	else
		key_string	= key.join(',')
		# If real key already exists, use it and create alias
		if key_strings.has(key_string)
			real_key	= key_strings.get(key_string)
			key_aliases.set(key, real_key)
			real_key
		else
			key
/**
 * @param {!Uint8Array} key
 */
!function increase_key_usage (key)
	key_string		= key.join(',')
	current_value	= key_usages.get(key)
	# On first use of real key create WeakMap alias to itself and string alias, set number of usages to 1
	if !current_value
		key_aliases.set(key, key)
		key_strings.set(key_string, key)
		key_usages.set(key, 1)
	else
		++current_value
		key_usages.set(key, current_value)
/**
 * @param {!Uint8Array} key
 */
!function decrease_key_usage (key)
	key_string		= key.join(',')
	current_value	= key_usages.get(key)
	--current_value
	# When last usage was eliminated, clean string alias and usages, WeakMap will clean itself over time or upon request (we can't enumerate its keys ourselves)
	if !current_offset
		key_strings.delete(key_string)
		key_usages.delete(key)
	else
		key_usages.set(key, current_value)

# LiveScript doesn't support classes, so we do it in ugly way
function U8Map
	/**
	 * This is a Map with very interesting property: different arrays with the same contents will be treated as the same array
	 *
	 * Implementation keeps weak references to make the whole thing fast and efficient
	 */
	new Map
		..get = (key) ->
			key	= get_unique_key(key)
			Map::get.call(@, key)
		..has	= (key) ->
			key	= get_unique_key(key)
			Map::has.call(@, key)
		..set = (key, value) ->
			key	= get_unique_key(key)
			if !Map::has.call(@, key)
				increase_key_usage(key)
			Map::set.call(@, key, value)
		..delete = (key) ->
			key	= get_unique_key(key)
			if Map::has.call(@, key)
				decrease_key_usage(key)
			Map::delete.call(@, key)
		..clear = !->
			@forEach (, key) !~>
				@delete(key)

U8Map:: = Object.create(Map::)

Object.defineProperty(U8Map::, 'constructor', {enumerable: false, value: U8Map})

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
		'U8Map'							: U8Map
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
