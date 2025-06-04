extends RefCounted

class_name ConnectionStatus

enum { DISCONNECTED = 0, CONNECTING = 1, CONNECTED = 2, ERROR = 3 } ## Status presentation

var state: int = DISCONNECTED

func reset() -> void:
	state = DISCONNECTED

func fail() -> void:
	state = ERROR

func start_connecting() -> void:
	state = CONNECTING

func succeed() -> void:
	state = CONNECTED

func in_progress() -> bool:
	return state == CONNECTING

func present() -> bool:
	return state == CONNECTED
