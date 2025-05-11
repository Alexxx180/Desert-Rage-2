extends RefCounted

class_name EncryptionSASL

var start: AuthMechanismDetermination
var main: SaslChallenge
var end: AuthGetProof

func set_backend(backend: Dictionary) -> void:
	var stats: SaslAuthenticationStats = SaslAuthenticationStats.new()
	stats.backend = backend
	for stage in [start, main, end]:
		stage.stats = stats

func encryption() -> bool:
	match type:
		10: start.require_auth()
		11: main.encryption()
		12: end.verify_proof()
		_: return false
	return true
