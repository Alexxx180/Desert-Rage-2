extends RefCounted

class_name EncryptionSalt

const END: int = 0xFF

var output: PackedByteArray = PackedByteArray()

func dig_key2(keys: Dictionary) -> void:
	for index in keys[1].size(): keys[2][index] ^= keys[1][index]

func dig_key1(meta: Dictionary, keys: Dictionary, iterations: int = 4096) -> void:
	for _index in iterations - 1:
		keys[1] = meta.crypto.hmac_digest(EncryptionSASL.HASH, meta.word, keys[1])
		dig_key2(keys)

func dig_keys(meta: Dictionary, iterations: int) -> PackedByteArray:
	var hmac: PackedByteArray = meta.crypto.hmac_digest(EncryptionSASL.HASH, meta.word, meta.key)
	var keys: Dictionary = { 1: hmac, 2: hmac }
	dig_key1(meta, keys, iterations)
	return keys[2]

func _shift(block: int, i: int) -> int:
	return ((block + 1) >> (24 - 8 * i)) & END

func _get_block_count(length: int, hashcode: int) -> int:
	return ceil((hashcode if length == 0 else length) / float(hashcode))

func pbkdf2(password: PackedByteArray, server: Dictionary, length: int = 0) -> void:
	# On devrait passer le mot de passe (credit.word) dans la fonction SASLprep (rfc7613) (or SASLprep, rfc4013) non implémenté si desous...
	var meta: Dictionary = { "crypto": Crypto.new(), "word": password }
	meta.length = len(meta.crypto.hmac_digest(EncryptionSASL.HASH, server.salt, meta.word))
	var buffer: PackedByteArray = PackedByteArray()
	buffer.resize(4)

	for block in _get_block_count(length, meta.length):
		for i in 3:
			print("i: ", i)
			buffer[i] = _shift(block, i)
		buffer[3] = (block + 1) & END
		meta.key = server.salt + buffer
		output += dig_keys(meta, server.iterations)

	output = output.slice(0, meta.length)

func clean() -> void:
	output = PackedByteArray()
