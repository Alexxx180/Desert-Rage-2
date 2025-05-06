func no_auth_support(type: int) -> bool:
	var _stop: bool = type == 2 or (type >= 5 and type <= 10)
	if _stop:
		var types: Dictionary = {
			2: "AuthenticationKerberosV5",
			6: "AuthenticationSCMCredential",
			7: "AuthenticationGSS",
			8: "AuthenticationGSSContinue",
			9: "AuthenticationSSPI"
		}
		### AuthenticationCredential ### Specifies that the credentials message is required. No support
		types.add._end_response(response_buffer, types[type] + " No support")
	return _stop

func auth_response() -> void:
	### Authentication ### Identifies the message as an authentication request.
	var authentication_type_data := responses.reverse(5, 10), 5)
	var authentication_type := buffer.get_32()

	if no_auth_support(authentication_type): return
	
	match authentication_type:
		0: status = Status.CONNECTING ### AuthenticationOk ### Specifies that the authentication was successful.
		3:
			### AuthenticationCleartextPassword ### Specifies that a clear-text password is required.
			response_buffer.resize(0)
			return request('p', password_global.to_utf8_buffer())
		5:
			### AuthentificationMD5Password ### Specifies that an MD5-encrypted password is required.
			var hashing_context = HashingContext.new()
			hashing_context.start(HashingContext.HASH_MD5)
			hashing_context.update((password_global + user_global).md5_buffer().hex_encode().to_ascii_buffer() + response_buffer.slice(9, 13))
			
			response_buffer.resize(0)
			return request('p', ("md5" + hashing_context.finish().hex_encode()).to_ascii_buffer() + byte())
		10:
			### AuthenticationSASL ###
			
			# Specifies that SASL authentication is required.
			
			# Get the message body is a list of SASL authentication mechanisms, in the server's order of preference. A zero byte is required as terminator after the last authentication mechanism name.
			# For each mechanism, there is the following:
			for name_sasl_authentication_mechanism in responses.split_byte(9, 0):
				match name_sasl_authentication_mechanism.get_string_from_ascii():
					"SCRAM-SHA-256":
						### SASLInitialResponse ###
						
						# Identifies the message as an initial SASL response. Note that this is also used for GSSAPI, SSPI and password response messages. The exact message type is deduced from the context.
						
						var crypto := Crypto.new()
						
						var nonce = Marshalls.raw_to_base64(crypto.generate_random_bytes(24))
						
						client_first_message = "%c,,n=%s,r=%s" % ['n', "", nonce] # When SCRAM-SHA-256 is used in PostgreSQL, the server will ignore the user name that the client sends in the client-first-message. The user name that was already sent in the startup message is used instead.
						
						var len_client_first_message := get_32ubyte_reverse(len(client_first_message))
						
						var sasl_initial_response := request('p', "SCRAM-SHA-256".to_ascii_buffer() + byte() + len_client_first_message + client_first_message.to_utf8_buffer())
						
						if stream_peer_tls.get_status() == StreamPeerTLS.STATUS_CONNECTED:
							stream_peer_tls.put_data(sasl_initial_response)
						else:
							peer.put_data(sasl_initial_response)
						
						response_buffer.resize(0)
						return
					"SCRAM-SHA-256-PLUS":
						continue # I'm still not done implementing SCRAM-SHA-256-PLUS, so we'll skip it for now.
						
						# /!\ Not end /!\
						
						### SASLInitialResponse ###
						
						# Identifies the message as an initial SASL response. Note that this is also used for GSSAPI, SSPI and password response messages. The exact message type is deduced from the context.
						
						var crypto := Crypto.new()
						
						var nonce = Marshalls.raw_to_base64(crypto.generate_random_bytes(24))
						
						client_first_message = "%c,,n=%s,r=%s" % ['y', "", nonce] # When SCRAM-SHA-256-PLUS is used in PostgreSQL, the server will ignore the user name that the client sends in the client-first-message. The user name that was already sent in the startup message is used instead.
						
						var len_client_first_message := get_32ubyte_reverse(len(client_first_message))
						
						var sasl_initial_response := request('p', "SCRAM-SHA-256-PLUS".to_ascii_buffer() + byte() + len_client_first_message + client_first_message.to_utf8_buffer())
						
						if stream_peer_tls.get_status() == StreamPeerTLS.STATUS_CONNECTED:
							stream_peer_tls.put_data(sasl_initial_response)
						else:
							peer.put_data(sasl_initial_response)
						
						response_buffer.resize(0)
						return
					# No implementation:
					"SCRAM-SHA-1": pass
					"SCRAM-SHA-1-PLUS": pass
					"CRAM-MD5": pass
					"CRAM-MD5-PLUS": pass
			types.add._end_response(response_buffer, " No SASL mechanism offered by the backend is supported by the frontend for SASL authentication.")
			return
		11:
			### AuthenticationSASLContinue ### Specifies that this message contains a SASL challenge. SCRAM-SHA-256
			var server_first_message = response_buffer.slice(9, message_length + 1).get_string_from_ascii()
			
			var server_nonce = server_first_message.split(',')[0].substr(2)
			var server_salt = Marshalls.base64_to_raw(server_first_message.split(',')[1].substr(2))
			var server_iterations := server_first_message.split(',')[2].substr(2).to_int()
			
			var client_final_message := "c=biws,r=%s" % [server_nonce]
			
			# On devrait passer le mot de passe (password_global) dans la fonction SASLprep (rfc7613) (or SASLprep, rfc4013) non implémenté si desous...
			salted_password = pbkdf2(HashingContext.HASH_SHA256, password_global.to_utf8_buffer(), server_salt, server_iterations)
			
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
			
			if stream_peer_tls.get_status() == stream_peer_tls.CONNECTED:
				stream_peer_tls.put_data(authentication_sasl_continue)
			else:
				peer.put_data(authentication_sasl_continue)
		12:
			### AuthenticationSASLFinal ### Specifies that SASL authentication has completed.
			
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
			
			# Get server proof response
			var server_proof_response = server_final_message.substr(2)
			
			if server_proof_response != Marshalls.raw_to_base64(server_signature):
				# /!\ We should normally trigger the "authentication_error" signal but it is still not implemented... /!\
				types.add._end_response(" An error occurred during SASL authentication. The SCRAM dialogue between the frontend and the backend does not end as expected. The server could not prove that it was in possession of ServerKey. The backend does not seem reliable for the frontend. The authentication attempt failed. Connection between frontend and backend interrupted.")
				return
		_:
			types.add._end_response(" The backend requires the frontend to use an authentication method that it does not support. Unknown authentication code.")
			return
