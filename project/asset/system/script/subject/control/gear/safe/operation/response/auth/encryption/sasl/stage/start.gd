extends RefCounted

class_name AuthMechanismDetermination

enum { SPLIT = 9, RANDOM = 24 }

signal stop()

var _stop: bool = false
var sha256: MechanismSHA256 = MechanismSHA256.new()

func _init() -> void: sha256.stop.connect(set_stop)
func no_implementation(name: String): print("No implementation: " + name)
func set_stop() -> void: _stop = false

func require_auth() -> void: # Get the message body is a list of SASL authentication mechanisms, in the server's order of preference.
	_stop = true
	for mechanism in sha256.stats.backend.responses.fragments.bytes(SPLIT):
		var name: String = mechanism.get_string_from_ascii()
		match name:
			"SCRAM-SHA-256": sha256.scram()
			"SCRAM-SHA-256-PLUS": sha256.scram_plus()
			"SCRAM-SHA-1": no_implementation(name)
			"SCRAM-SHA-1-PLUS": no_implementation(name)
			"CRAM-MD5": no_implementation(name)
			"CRAM-MD5-PLUS": no_implementation(name)
	if _stop:
		sha256.stats.backend.connection.note.end_response("no_sasl")
		stop.emit()
