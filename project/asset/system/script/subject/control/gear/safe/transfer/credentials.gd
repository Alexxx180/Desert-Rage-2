extends RefCounted

class_name EncryptionCredentials

################ The process ID and secret of this backend.
var backend: Dictionary = { "id": 0, "secret": 0 }
################ No use at the moment

var word: String
var user: String
var url: String

func safe_reset() -> void:
	word = ""
	user = ""

func cancel(responses) -> void: # Must have values to be able to issue CancelRequest messages later. Get the:
	backend.id = responses.reverse(4, 5, 9).get_u32()# ... process ID of this backend.
	backend.secret = responses.reverse(0, 9, responses.length + 1).get_u32()# ... secret key of this backend.

func set_data(result: Array) -> void:
	word = result[2]
	user = result[1]
