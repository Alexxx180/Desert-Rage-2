extends RefCounted

class_name EncryptionSASL

var start: AuthMechanismDetermination
var main: SaslChallenge
var end: AuthGetProof

func encryption(object: Dictionary) -> bool:
	match type:
		10: start.require_auth()
		11: main.encryption()
		12: end.verify_proof()
		_: return false
	return true
