/**
 * @package Detox utils
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
lib		= require('..')
test	= require('tape')

test('Utils', (t) !->
	t.plan(22)

	random1 = lib.random_bytes(10)
	random2 = lib.random_bytes(10)
	t.ok(random1 instanceof Uint8Array, 'Random bytes are in Uint8Array')
	t.equal(random1.length, 10, 'Random bytes of correct length')
	t.notEqual(random1.join(','), random2.join(','), 'Random bytes are random')

	random_int1 = lib.random_int(1, 999)
	random_int2 = lib.random_int(1, 999)
	t.notEqual(random_int1, random_int2, 'Random ints are random')

	array		= [1, 2, 3]
	random_item	= lib.pull_random_item_from_array(array)
	t.equal(array.length, 2, 'Pulled item from array')

	hex_array	= Uint8Array.of(1, 2, 3, 5, 6)
	hex			= '0102030506'
	t.equal(lib.array2hex(hex_array), hex, 'Array to hex converted correctly')
	t.equal(lib.hex2array(hex).join(','), hex_array.join(','), 'Hex to array converted correctly')

	string			= 'Hello, world 😊'
	string_array	= Uint8Array.of(72, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 32, 240, 159, 152, 138)
	t.equal(lib.string2array(string).join(','), string_array.join(','), 'String to Uint8Array converted correctly')
	t.equal(lib.array2string(string_array), string, 'Uint8Array to string converted correctly')

	t.ok(lib.are_arrays_equal(Uint8Array.from(hex_array), hex_array), 'Arrays are equal')
	t.notOk(lib.are_arrays_equal(hex_array, string_array), 'Arrays are not equal')

	array1			= Uint8Array.of(1, 2)
	array2			= Uint8Array.of(3, 4)
	arrays_result	= Uint8Array.of(1, 2, 3, 4)
	concatenated	= lib.concat_arrays([array1, array2])
	t.equal(concatenated.length, 4, 'Concatenated array has expected length')
	t.ok(concatenated instanceof Uint8Array, 'Concatenated array is Uint8Array')
	t.equal(concatenated.join(','), arrays_result.join(','), 'Concatenated array has expected contents')

	map		= new lib.ArrayMap
	u8_1	= Uint8Array.of(1, 2, 3)
	u8_2	= Uint8Array.of(1, 2, 3)
	t.equal(map.size, 0, 'ArrayMap empty initially')
	t.notOk(map.has(u8_1), "ArrayMap doesn't have array initially")
	map.set(u8_1, u8_1)
	t.ok(map.has(u8_1), 'ArrayMap has item after addition')
	t.ok(map.has(u8_2), 'ArrayMap has item that is a different array, but with the same contents')

	x = 0
	lib.timeoutSet(0.001, !->
		++x
	)
	clearTimeout(lib.timeoutSet(0.001, !->
		++x
	))
	setTimeout (!->
		t.equal(x, 1, 'timeoutSet works correctly')
	), 50

	y	= 0
	i1	= lib.intervalSet(0.001, !->
		++y
	)
	clearInterval(lib.intervalSet(0.001, !->
		++x
	))
	setTimeout (!->
		clearInterval(i1)
		t.notEqual(y, 0, 'intervalSet works correctly')
		t.equal(x, 1, 'intervalSet works correctly')
	), 100

	setTimeout (!->
		console_error	= console.error
		console.error	= !->
			console.error	= console_error
			t.pass('error_handler catches errors')
		(new Promise !->
			throw new Error
		).catch(lib.error_handler)
	), 200

	setTimeout (!->
		console.error	= !->
			console.error	= console_error
			t.fail("error_handler doesn't catch other things")
		(new Promise !->
			throw 'Hello there'
		).catch(lib.error_handler)
	), 300
)
