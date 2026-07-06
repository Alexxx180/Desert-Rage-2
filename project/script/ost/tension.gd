extends Timer

signal change_danger(finished: bool)

@onready var reorder: Timer = $reorder

var environment: Array[String] = ["ambient", "heating", "rampage"]
var _enemies: int = 0
var _adjust: Vector2i = Vector2.ZERO
var _selection: int = 0
var _previous: int = _selection
var _spawn: bool = false

var previous_state: String:
	get: return environment[_previous]
var state: String:
	get: return environment[_selection]

func _ready() -> void: timeout.connect(sync_enemy_music)

func add_enemy(_body) -> void:
	_adjust.x += 1
	reorder.start()
	#match_enemy()

func drop_enemy(_body) -> void:
	_adjust.y += 1
	reorder.start()
	#match_enemy()

func sync_enemy_music() -> void:
	var delta: int = _adjust.x - _adjust.y
	_enemies += delta
	_adjust = Vector2.ZERO
	if delta != 0:
		match_enemy()

func add_spawn(_body) -> void: _spawn = true
func drop_spawn(_body) -> void: _spawn = false

func match_enemy() -> void:
	_previous = _selection
	match _enemies:
		0: _selection = 0
		1, 2:
			if _selection != 2:
				_selection = 1
		_: _selection = 2 if _spawn else 1
	if _selection != _previous:
		change_danger.emit(false)
