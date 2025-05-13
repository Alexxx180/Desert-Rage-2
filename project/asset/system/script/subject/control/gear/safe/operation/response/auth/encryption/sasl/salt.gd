extends RefCounted

class_name EncryptionSalt

const END: int = 0xFF

var context: HashingContext.HashType = HashingContext.HASH_SHA256
var output: PackedByteArray = PackedByteArray()

func hmac(crypto: Crypto, word: PackedByteArray, key: PackedByteArray) -> PackedByteArray:
	return crypto.hmac_digest(context, word, key)

func dig_key2(keys: Dictionary) -> void:
	for index in keys[1].size(): keys[2][index] ^= keys[1][index]

func dig_key1(hash: Dictionary, keys: Dictionary, iterations: int = 4096) -> void:
	for _index in iterations - 1:
		keys[1] = hmac(hash.crypto, hash.word, keys[1])
		dig_key2(keys)

func dig_keys(hash: Dictionary, iterations: int) -> PackedByteArray:
	var keys: Dictionary = { 1: hmac(hash.crypto, hash.word, hash.key) }
	keys[2] = keys[1]
	dig_key1(hash, keys, iterations)
	return keys[2]

func _shift(block: int, i: int) -> int:
	return ((block + 1) >> (24 - 8 * i)) & END

func _get_block_count(length: int, hash: int) -> int:
	return ceil((hash if length == 0 else length) / float(hash))

func pbkdf2(password: PackedByteArray, server: Dictionary, length: int = 0) -> void:
	# On devrait passer le mot de passe (credit.word) dans la fonction SASLprep (rfc7613) (or SASLprep, rfc4013) non implémenté si desous...
	var hash: Dictionary = { "crypto": Crypto.new(), "word": password }
	hash.length = len(hmac(hash.crypto, server.salt, hash.word))
	var buffer: PackedByteArray = PackedByteArray()
	buffer.resize(4)

	for block in _get_block_count(length, hash.length):
		for i in 3: buffer[i] = _shift(block, i)
		buffer[3] = (block + 1) & END
		hash.key = server.salt + buffer
		output += dig_keys(hash, server.iterations)

	output = output.slice(0, hash.length)

func output_safe() -> PackedByteArray:
	var clone: PackedByteArray = output
	output.resize(0)
	return clone
