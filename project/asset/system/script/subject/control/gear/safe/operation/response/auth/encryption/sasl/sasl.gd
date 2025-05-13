extends RefCounted

class_name EncryptionSASL

var start: AuthMechanismDetermination = AuthMechanismDetermination.new()
var main: SaslChallenge = SaslChallenge.new()
var end: AuthGetProof = AuthGetProof.new()

var backend: Dictionary: set = set_backend

func set_backend(value: Dictionary) -> void:
	var stats: SaslAuthenticationStats = SaslAuthenticationStats.new()
	stats.backend = value
	for stage in [start, main, end]:
		stage.stats = stats

func encryption(type: int) -> bool:
	match type:
		10: start.require_auth()
		11: main.encryption()
		12: end.verify_proof()
		_: return false
	return true
