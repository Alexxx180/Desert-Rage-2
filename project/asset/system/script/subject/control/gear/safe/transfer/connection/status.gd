extends RefCounted

class_name ConnectionStatus

enum { DISCONNECTED, CONNECTING, CONNECTED, ERROR } ## Status presentation

var state: int = DISCONNECTED

func reset() -> void:
	state = DISCONNECTED

func fail() -> void:
	state = ERROR

func succeed() -> void:
	state = CONNECTED

func in_progress() -> bool:
	return state == CONNECTING

func present() -> bool:
	return state == CONNECTED
