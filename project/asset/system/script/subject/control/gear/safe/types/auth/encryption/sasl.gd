extends RefCounted

class_name EncryptionSASL

var _stop: bool = false
var peers: TransferPeers
var credit: EncryptionCredentials
# Authentication SASL
var client_first_message: String 
var salted_password: PackedByteArray
var auth_message: String

func dig_key2(key_1: PackedByteArray) -> void:
	for index in key_1.size():
		key_2[index] ^= key_1[index]

func dig_key1(hash_type: int, password: PackedByteArray, key_1: PackedByteArray) -> void:
	for _index in iterations - 1:
		key_1 = crypto.hmac_digest(hash_type, password, key_1)
		dig_key2(key1)

func pbkdf2(hash_type: int, password: PackedByteArray, salt: PackedByteArray, iterations := 4096, length := 0) -> PackedByteArray:
	const END = 0xFF
	var crypto: Crypto = Crypto.new()
	var hash_length: int = len(crypto.hmac_digest(hash_type, salt, password))

	if length == 0: length = hash_length
	
	var output: PackedByteArray = PackedByteArray()
	var block_count: int = ceil(length / float(hash_length))
	
	var buffer: PackedByteArray = PackedByteArray()
	buffer.resize(4)
	
	for block in block_count:
		for i in 3: buffer[i] = (int(block + 1) >> (24 - 8 * i)) & END
		buffer[3] = int(block + 1) & END
		
		var key_1 := crypto.hmac_digest(hash_type, password, salt + buffer)
		var key_2 := key_1
		dig_key1(hash_type, password, key_1)

		output += key_2
	
	return output.slice(0, hash_length)

func _get_reversed(buffer, method: Callable) -> PackedByteArray:
	method.call(buffer)
	var bytes: = buffer.data_array
	bytes.reverse()
	return bytes

func get_32ubyte_reverse(value: iny) -> void:
	return _get_reversed(StreamPeerBuffer.new(), func(b): b.put_u32(value))

func get_32byte_reverse(value: int) -> PackedByteArray:
	return _get_reversed(StreamPeerBuffer.new(), func(b): b.put_32(value))

func parse_version(buffer) -> void:# Version parsing
	var zeros: int = 2
	var major = int(PROTOCOL_VERSION)
	var minor = major - PROTOCOL_VERSION
	for char_number in str(major).pad_zeros(zeros) + str(minor).pad_zeros(zeros):
		buffer.put_data(PackedByteArray([char_number.to_int()]))

func _get_sha_256_hex(postfix: String) -> PackedByteArray:
	return ("SCRAM-SHA-256" + postfix).to_ascii_buffer()

func scram_sha_256(type: String = 'n', postfix: String = ""): # SASL. Also used for GSSAPI, SSPI and not implemented messages.
	var crypto := Crypto.new() # The exact message type is deduced from the context.
	var nonce = Marshalls.raw_to_base64(crypto.generate_random_bytes(24))
	
	client_first_message = "%c,,n=%s,r=%s" % [type, "", nonce] # When SCRAM-SHA-256 is used in PostgreSQL, the server will ignore the user name that the client sends in the client-first-message. The user name that was already sent in the startup message is used instead.
	
	var len_client_first_message := get_32ubyte_reverse(len(client_first_message))
	var sasl_initial_response := op.p(responses, _get_sha_256_hex(postfix) + byte() + len_client_first_message + client_first_message.to_utf8_buffer())
	peers.by_connection().put_data(sasl_initial_response) # responses.resize(0)

func scram_sha_256_plus() -> void:# Not done implementing SCRAM-SHA-256-PLUS
	_stop = false
	if _stop: scram_sha_256('y', '-PLUS') # /!\ Not end /!\

func no_implementation(name: String): print("No implementation: " + name)

func encryption_start() -> bool:# Specifies that SASL authentication is required.
	_stop = true # Get the message body is a list of SASL authentication mechanisms, in the server's order of preference. A zero byte is required as terminator after the last authentication mechanism name. For each mechanism, there is the following:
	for sasl_authentication_mechanism in responses.split_byte(9, 0):
		var name: String = sasl_authentication_mechanism.get_string_from_ascii()
		match name:
			"SCRAM-SHA-256": scram_sha_256()
			"SCRAM-SHA-256-PLUS": scram_sha_256_plus()
			"SCRAM-SHA-1": no_implementation(name)
			"SCRAM-SHA-1-PLUS": no_implementation(name)
			"CRAM-MD5": no_implementation(name)
			"CRAM-MD5-PLUS": no_implementation(name)
	types.add._end_response(response_buffer, " No SASL mechanism offered by the backend is supported by the frontend for SASL authentication.")
	return _stop

func encryption_continue() -> bool:# Specifies that this message contains a SASL challenge. SCRAM-SHA-256
	var server_first_message = response_buffer.slice(9, message_length + 1).get_string_from_ascii()
	
	var server_nonce = server_first_message.split(',')[0].substr(2)
	var server_salt = Marshalls.base64_to_raw(server_first_message.split(',')[1].substr(2))
	var server_iterations := server_first_message.split(',')[2].substr(2).to_int()
	
	var client_final_message := "c=biws,r=%s" % [server_nonce]
	
	# On devrait passer le mot de passe (credit.word) dans la fonction SASLprep (rfc7613) (or SASLprep, rfc4013) non implémenté si desous...
	salted_password = pbkdf2(HashingContext.HASH_SHA256, credit.word.to_utf8_buffer(), server_salt, server_iterations)

	var crypto = Crypto.new()
	var client_key = crypto.hmac_digest(HashingContext.HASH_SHA256, salted_password, "Client Key".to_ascii_buffer())
	
	var hashing_context = HashingContext.new()
	hashing_context.start(HashingContext.HASH_SHA256)
	hashing_context.update(client_key)
	var stored_key = hashing_context.finish()
	
	# AuthMessage is just a concatenation of the initial client message, server challenge, and client response (without ClientProof).
	var client_first_message_bare = client_first_message.substr(3)
	client_first_message = ""
	
	auth_message = client_first_message_bare + ',' + server_first_message + ',' + client_final_message
	var client_signature = crypto.hmac_digest(HashingContext.HASH_SHA256, stored_key, auth_message.to_utf8_buffer())
	
	var client_proof_buffer := PackedByteArray()
	for index in client_key.size():
		client_proof_buffer.append(client_key[index] ^ client_signature[index])
	
	var client_proof := Marshalls.raw_to_base64(client_proof_buffer)
	
	client_final_message += ",p=" + client_proof
	
	var authentication_sasl_continue := request('p', client_final_message.to_ascii_buffer())

	peers.by_connection().put_data(authentication_sasl_continue)

func get_server_proof(signature) -> bool:# Get server proof response
	return server_final_message.substr(2) != Marshalls.raw_to_base64(signature)

func encryption_end() -> bool:# Specifies that SASL authentication has completed.
	var server_final_message = response_buffer.slice(9, message_length + 1).get_string_from_ascii()
	
	# The client verifies the proof from the server by calculating the ServerKey and the ServerSignature, then comparing its ServerSignature to that received from the server. If they are the same, the client has proof that the server has access to the ServerKey.
	var crypto = Crypto.new()
	var server_key = crypto.hmac_digest(HashingContext.HASH_SHA256, salted_password, "Server Key".to_ascii_buffer())
	
	salted_password.resize(0)
	
	var server_signature = crypto.hmac_digest(HashingContext.HASH_SHA256, server_key, auth_message.to_utf8_buffer())
	auth_message = ""
	
	var server_proof := PackedByteArray()
	for index in server_key.size():
		server_proof.append(server_key[index] ^ server_signature[index])
	
	_stop = get_server_proof(server_signature)
	if _stop:  note.end_response("sasl_auth_error") # /!\ "authentication_error" signal not properly implemented...
	return _stop
