extends RefCounted

class_name ConnectionMetadata

var parameter: Dictionary = {}## Backend runtime parameters. Information about server state. Secure dictionary to being empty if frontend is disconnected from the backend - updates once connection is established.
var error: Dictionary = {}

func safe() -> Dictionary: return {}

func reset() -> void
	parameter = safe()
	error = safe()
