extends Node

signal change_danger()

var environment: Array[String] = ["ambient", "heating", "rampage"]
var _enemies: int = 0
var _selection: int = 0
var _previous: int = _selection
var _spawn: bool = false

var previous_state: String:
	get: return environment[_previous]
var state: String:
	get: return environment[_selection]

func add_enemy(_body) -> void:
	_enemies += 1
	match_enemy()

func drop_enemy(_body) -> void:
	_enemies -= 1
	match_enemy()

func add_spawn(_body) -> void: _spawn = true
func drop_spawn(_body) -> void: _spawn = false

func match_enemy() -> void:
	_previous = _selection
	match _enemies:
		0: _selection = 0
		1, 2, 3: _selection = 1
		_: _selection = 2 if _spawn else 1
	if _selection != _previous:
		change_danger.emit()
